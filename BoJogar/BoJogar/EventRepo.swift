import Foundation

struct EventRepo {
    var subscriberDetails: [UserModel]
    var event: EventModel
    private let subscriberDetailsFileName: String
    private let eventFileName: String
    
    init(event: EventModel) {
        self.event = event
        self.subscriberDetails = []
        self.subscriberDetailsFileName = "subscribers_\(event.id ?? "1").json"
        self.eventFileName = "event_\(event.id ?? "1").json"
        loadSubscriberDetailsFromLocalStorage()
        loadEventFromLocalStorage()
    }
    
    private func localFilePath(for fileName: String) -> URL {
        let documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        return documentDirectory.appendingPathComponent(fileName)
    }
    
    private func saveSubscriberDetailsToLocalStorage() {
        let encoder = JSONEncoder()
        do {
            let data = try encoder.encode(subscriberDetails)
            try data.write(to: localFilePath(for: subscriberDetailsFileName))
        } catch {
            print("Failed to save subscriber details to local storage: \(error)")
        }
    }
    
    private mutating func loadSubscriberDetailsFromLocalStorage() {
        let path = localFilePath(for: subscriberDetailsFileName)
        guard FileManager.default.fileExists(atPath: path.path) else { return }
        
        let decoder = JSONDecoder()
        do {
            let data = try Data(contentsOf: path)
            subscriberDetails = try decoder.decode([UserModel].self, from: data)
        } catch {
            print("Failed to load subscriber details from local storage: \(error)")
        }
    }
    
    private func saveEventToLocalStorage() {
        let encoder = JSONEncoder()
        do {
            let data = try encoder.encode(event)
            try data.write(to: localFilePath(for: eventFileName))
        } catch {
            print("Failed to save event to local storage: \(error)")
        }
    }
    
    private mutating func loadEventFromLocalStorage() {
        let path = localFilePath(for: eventFileName)
        guard FileManager.default.fileExists(atPath: path.path) else { return }
        
        let decoder = JSONDecoder()
        do {
            let data = try Data(contentsOf: path)
            event = try decoder.decode(EventModel.self, from: data)
        } catch {
            print("Failed to load event from local storage: \(error)")
        }
    }
}

//Extension for async functions
extension EventRepo {
    mutating func getSubscribersDetails() async {
        let url = URL(string: "\(API_BASE_URL)/events/\(event.id ?? "1")/subscribers_details")!
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        do {
            let (data, _) = try await URLSession.shared.data(for: request)
            
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            let subscriberDetailsInDB = try decoder.decode([UserModelInDB].self, from: data)
            let subscriberDetails = subscriberDetailsInDB.map{subscriber in
                UserModel(id: subscriber._id,
                          username: subscriber.username,
                          email: subscriber.email,
                          firstName: subscriber.firstName,
                          lastName:subscriber.lastName,
                          bio: subscriber.bio,
                          imageURL: subscriber.imageURL)
            }
            self.subscriberDetails = subscriberDetails // Using 'self' with 'mutating' method
            self.event.subscribers  = subscriberDetails.map{ $0.id }
            saveSubscriberDetailsToLocalStorage() // Save to local storage
            
        } catch {
            print(error.localizedDescription)
        }
    }
    
    mutating func removeSubscriber(userID: String) async throws {
        let url = URL(string: "\(API_BASE_URL)/events/\(event.id ?? "1")/remove_sub")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("true", forHTTPHeaderField: "ngrok-skip-browser-warning")
        
        let encoder = JSONEncoder()
        
        do {
            let userBody = try encoder.encode(["userId": userID])
            request.httpBody = userBody
            
            let (data, response) = try await URLSession.shared.data(for: request)
            
            if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 {
                let decoder = JSONDecoder()
                do {
                    let updatedSubscribers = try decoder.decode([String].self, from: data)
                    self.event.subscribers = updatedSubscribers
                    saveEventToLocalStorage() // Save to local storage
                    await self.getSubscribersDetails()
                } catch {
                    print("Error decoding response data: \(error)")
                }
                
            } else {
                print("Failed to remove subscriber.")
            }
        } catch {
            print("Error removing subscriber: \(error)")
            throw error
        }
    }
    
    mutating func toggleSubscribe(userID: String) async throws {
        let url = URL(string: "\(API_BASE_URL)/events/\(event.id ?? "1")/toggleSubscription")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let encoder = JSONEncoder()
        
        do {
            let userBody = try encoder.encode(["userId": userID])
            request.httpBody = userBody
            
            let (data, response) = try await URLSession.shared.data(for: request)
            
            if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 {
                let decoder = JSONDecoder()
                do {
                    if (self.event.subscribers.contains(userID)){
                        if let index = self.event.subscribers.firstIndex(of: userID) {
                            self.event.subscribers.remove(at: index)
                        }
                    }else{
                        self.event.subscribers.append(userID)
                    }
                    
                    let updatedSubscribers = try decoder.decode([String].self, from: data)
                    self.event.subscribers = updatedSubscribers
                    await self.getSubscribersDetails()
                    saveEventToLocalStorage() // Save to local storage

                } catch {
                    print("Error decoding response data: \(error)")
                }
                
            } else {
                print("Failed to toggle subscription.")
            }
        } catch {
            print("Error toggling subscription: \(error)")
            throw error
        }
    }
}
