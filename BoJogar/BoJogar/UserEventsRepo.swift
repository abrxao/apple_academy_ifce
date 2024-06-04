import Foundation

struct UserEventsRepo {
    var events: [EventCardModel]
    var userId: String
    
    init(userId: String) {
        self.events = []
        self.userId = userId
    }
    
    mutating func deleteEventLocal(withId id: String) {
        events.removeAll { $0.id == id }
    }
}

extension UserEventsRepo {
    mutating func getUserEvents() async {
        let url = URL(string: "\(API_BASE_URL)/users/\(self.userId)/events_details")!
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("true", forHTTPHeaderField: "ngrok-skip-browser-warning")
        do {
            
            let (data, _) = try await URLSession.shared.data(for:request)
            
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            let decodedData = try decoder.decode([EventCardModel].self, from: data)
            self.events = decodedData // Using 'self' with 'mutating' method
            
        } catch {
            print(error.localizedDescription)
        }
    }
    
    mutating func deleteEvent(withId id: String) async {
        let url = URL(string: "\(API_BASE_URL)/events/\(id)")!
        var request = URLRequest(url: url)
        request.httpMethod = "DELETE"
        request.setValue("true", forHTTPHeaderField: "ngrok-skip-browser-warning")
        do {
            let (_, response) = try await URLSession.shared.data(for: request)
            if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 {
                
                self.deleteEventLocal(withId: id)
                // Optionally, you can update your local events array or UI here
            } else {
                print("Failed to delete event with ID \(id).")
            }
        } catch {
            print("Error deleting event with ID \(id): \(error)")
        }
    }
    
    mutating func addEvent(event: EventCardModel) async throws {
            let url = URL(string: "\(API_BASE_URL)/events")!
            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            request.setValue("true", forHTTPHeaderField: "ngrok-skip-browser-warning")
            let encoder = JSONEncoder()
            
            do {
                let eventData = try encoder.encode(event)
                request.httpBody = eventData
                
                let (data, response) = try await URLSession.shared.data(for: request)
                
                if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 201 {
                    print("Event added successfully.")
                    // Optionally, you can handle the response data here
                    let decoder = JSONDecoder()
                    do {
                        let addedEvent = try decoder.decode(EventCardModel.self, from: data)
                        events.append(addedEvent)
                        // Assuming 'events' is your array of EventCardModel
                    } catch {
                        print("Error decoding response data: \(error)")
                    }
                    
                } else {
                    print("Failed to add event.")
                }
            } catch {
                print("Error adding event: \(error)")
                throw error
            }
        }

}
