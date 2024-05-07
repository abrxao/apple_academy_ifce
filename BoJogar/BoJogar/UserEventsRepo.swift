import Foundation

struct UserEventsRepo {
    var events: [EventCardModel]
    init() {
        self.events = []
    }
    mutating func deleteEventLocal(withId id: String) {
        events.removeAll { $0.id == id }
    }
}

extension UserEventsRepo {
    mutating func fetchEvents() async {
        guard let url = URL(string: "http://localhost:3001/events") else {
            print("erro1")
            return
        }
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            let decodedData = try decoder.decode([EventCardModel].self, from: data)
            self.events = decodedData // Using 'self' with 'mutating' method
            
        } catch {
            print("erro2")
        }
    }
    
    mutating func deleteEvent(withId id: String) async {
        let url = URL(string: "http://localhost:3001/events/\(id)")!
        var request = URLRequest(url: url)
        request.httpMethod = "DELETE"

        do {
            let (_, response) = try await URLSession.shared.data(for: request)
            if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 {
                print("Event with ID \(id) deleted successfully.")
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
            let url = URL(string: "http://localhost:3001/events")!
            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            
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
