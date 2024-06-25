//
//  UserRepo.swift
//  BoJogar
//
//  Created by found on 14/06/24.
//

import Foundation
import Observation

@Observable
class UserRepo: ObservableObject {
    var events: [EventModel]
    var userId: String
    var isLoadingEvents: Bool = false
    var userData: UserModel?
    private let localFileName: String
    var numOfUserEvents: Int = 0
    
    init(userId: String) {
        self.events = []
        self.userId = userId
        self.localFileName = "user_events_\(userId).json"
        loadEventsFromLocalStorage()
    }
    
    func deleteEventLocal(withId id: String) {
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
    
    private func saveUserToLocalStorage() {
        let encoder = JSONEncoder()
        do {
            let data = try encoder.encode(userData)
            try data.write(to: localFilePath())
        } catch {
            print("Failed to save events to local storage: \(error)")
        }
    }
    
    private  func loadEventsFromLocalStorage() {
        let path = localFilePath()
        guard FileManager.default.fileExists(atPath: path.path) else { return }
        
        let decoder = JSONDecoder()
        do {
            let data = try Data(contentsOf: path)
            events = try decoder.decode([EventModel].self, from: data)
        } catch {
            print("Failed to load events from local storage: \(error)")
        }
    }
}

extension UserRepo {
    func getUserEvents() async {
        self.isLoadingEvents = true
        let url = URL(string: "\(API_BASE_URL)/users/\(self.userId)/events_details")!
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        do {
            let (data, _) = try await URLSession.shared.data(for:request)
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            let eventsInDb = try decoder.decode([EventModelInDB].self, from: data)
            let userEvents = eventsInDb.map{event in
                EventModel(id: event._id,
                           creatorId: event.creatorId,
                           title: event.title,
                           description: event.description,
                           startDate: event.startDate,
                           endDate: event.endDate,
                           sport: event.sport,
                           maxAttendees: event.maxAttendees,
                           localID: event.localID,
                           subscribers: event.subscribers)
            }
            self.events = userEvents
            let _userEvents = userEvents.filter{$0.creatorId == userId}
            self.numOfUserEvents = _userEvents.count
            saveEventsToLocalStorage() // Save to local storage
        } catch {
            print(error.localizedDescription)
        }
        
        self.isLoadingEvents = false
    }
    
    func getUserData() async{
        let url = URL(string: "\(API_BASE_URL)/users/\(self.userId)")!
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        do {
            let (data,_) = try await URLSession.shared.data(for:request)
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            let userDataInDb = try decoder.decode(UserModelInDB.self, from: data)
            let userData_ =
                UserModel(id: userDataInDb._id,
                          username: userDataInDb.username,
                          email: userDataInDb.email,
                          firstName: userDataInDb.firstName,
                          lastName:userDataInDb.lastName,
                          bio: userDataInDb.bio,
                          imageURL: userDataInDb.imageURL)
            userData = userData_
            saveEventsToLocalStorage() // Save to local storage
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func deleteEvent(withId id: String) async {
        let url = URL(string: "\(API_BASE_URL)/events/\(id)")!
        var request = URLRequest(url: url)
        request.httpMethod = "DELETE"
        
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
    
    func addEvent(event: EventModelRequest) async throws {
        let url = URL(string: "\(API_BASE_URL)/events")!
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
                let decoder = JSONDecoder()
                do {
                    let addedEvent = try decoder.decode(EventModel.self, from: data)
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
    
    func editEvent(eventId: String, updatedEvent: EventModelRequest) async throws {
            let url = URL(string: "\(API_BASE_URL)/events/\(eventId)")!
            var request = URLRequest(url: url)
            request.httpMethod = "PATCH"
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        print(updatedEvent.subscribers)
            let encoder = JSONEncoder()
            
            do {
                let eventData = try encoder.encode(updatedEvent)
                request.httpBody = eventData
                let (data, response) = try await URLSession.shared.data(for: request)
                print(response)
                if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 {
                    print("Event updated successfully.")
                    let decoder = JSONDecoder()
                    do {
                        let updatedEvent = try decoder.decode(EventModel.self, from: data)
                        if let index = events.firstIndex(where: { $0.id == eventId }) {
                            events[index] = updatedEvent
                            saveEventsToLocalStorage() // Save to local storage
                        }
                    } catch {
                        print("Error decoding response data: \(error)")
                    }
                } else {

                    print("Failed to update event.")
                }
            } catch {
                print("Error updating event: \(error)")
                throw error
            }
        }
    
}
