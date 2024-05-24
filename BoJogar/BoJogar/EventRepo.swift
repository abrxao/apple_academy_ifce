import Foundation

struct EventRepo {
    var subscriberDetails: [UserModel]
    var event: EventCardModel
    
    init(event: EventCardModel) {
        
        self.event = event
        self.subscriberDetails = []
    }
}

extension EventRepo {
    mutating func getSubscribersDetails() async {
        guard let url = URL(string: "http://localhost:3001/events/\(self.event.id)/subscribers_details") else {
            print("Invalid URL")
            return
        }
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            let decodedData = try decoder.decode([UserModel].self, from: data)
            self.subscriberDetails = decodedData // Using 'self' with 'mutating' method
            
        } catch {
            print(error.localizedDescription)
        }
    }
    
    mutating func toggleSubscribe(userID: String) async throws {
        let url = URL(string: "http://localhost:3001/events/\(event.id)/toggleSubscription")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let encoder = JSONEncoder()
        
        do {
            let userBody = try encoder.encode(["userId": userID])
            request.httpBody = userBody
            
            let (data, response) = try await URLSession.shared.data(for: request)
            
            if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 {
                print("Subscription toggled successfully.")
                // Optionally, you can handle the response data here
                let decoder = JSONDecoder()
                do {
                    let updatedSubscribers = try decoder.decode([String].self, from: data)
                    print(updatedSubscribers)
                    self.event.subscribers = updatedSubscribers
                    await self.getSubscribersDetails()
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
