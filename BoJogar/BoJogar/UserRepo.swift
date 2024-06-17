//
//  UserRepo.swift
//  BoJogar
//
//  Created by found on 14/06/24.
//

import Foundation

struct UserEventsRepo {
    var events: [EventCardModel]
    var userId: String
    private let localFileName: String
    var numOfUserEvents: Int = 0
    
    init(userId: String) {
        self.events = []
        self.userId = userId
        self.localFileName = "user_events_\(userId).json"
        loadEventsFromLocalStorage()
    }
    
    mutating func deleteEventLocal(withId id: String) {
        events.removeAll { $0.id == id }
        saveEventsToLocalStorage()
    }
    
    private func localFilePath() -> URL {
        let documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        return documentDirectory.appendingPathComponent(localFileName)
    }
    
    private func saveEventsToLocalStorage() {
        let encoder = JSONEncoder()
        do {
            let data = try encoder.encode(events)
            try data.write(to: localFilePath())
        } catch {
            print("Failed to save events to local storage: \(error)")
        }
    }
    
    private mutating func loadEventsFromLocalStorage() {
        let path = localFilePath()
        guard FileManager.default.fileExists(atPath: path.path) else { return }
        
        let decoder = JSONDecoder()
        do {
            let data = try Data(contentsOf: path)
            events = try decoder.decode([EventCardModel].self, from: data)
        } catch {
            print("Failed to load events from local storage: \(error)")
        }
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
            let userEvents = decodedData.filter{$0.creatorId == USER_ID_TESTE}
            self.numOfUserEvents = userEvents.count
            saveEventsToLocalStorage() // Save to local storage
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
                let decoder = JSONDecoder()
                do {
                    let addedEvent = try decoder.decode(EventCardModel.self, from: data)
                    events.append(addedEvent)
                    saveEventsToLocalStorage() // Save to local storage
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
