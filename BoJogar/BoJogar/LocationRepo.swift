import Foundation
import SwiftUI
import Observation

@Observable
class LocationRepo {
    var events: [EventModel] = []
    var location: LocationModel
    private let eventsFileName: String
    private let localDataFileName: String
    
    init(location: LocationModel) {
        self.events = []
        self.location = location
        self.eventsFileName = "local_events_\(location.id ?? "1").json"
        self.localDataFileName = "localData_\(location.id ?? "1").json"
        loadEventsFromLocalStorage()
        loadLocationDataFromLocalStorage()
    }
    
    func deleteEventLocal(withId id: String) {
        events.removeAll { $0.id == id }
        saveEventsToLocalStorage()
    }
    
    private func localFilePath(for fileName: String) -> URL {
        let documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        return documentDirectory.appendingPathComponent(fileName)
    }
    
    private func saveEventsToLocalStorage() {
        let encoder = JSONEncoder()
        do {
            let data = try encoder.encode(events)
            try data.write(to: localFilePath(for: eventsFileName))
        } catch {
            print("Failed to save events to local storage: \(error)")
        }
    }
    
    private func loadEventsFromLocalStorage() {
        let path = localFilePath(for: eventsFileName)
        guard FileManager.default.fileExists(atPath: path.path) else { return }
        
        let decoder = JSONDecoder()
        do {
            let data = try Data(contentsOf: path)
            events = try decoder.decode([EventModel].self, from: data)
        } catch {
            print("Failed to load events from local storage: \(error)")
        }
    }
    
    private func saveLocationDataToLocalStorage() {
        let encoder = JSONEncoder()
        do {
            let data = try encoder.encode(location)
            try data.write(to: localFilePath(for: localDataFileName))
        } catch {
            print("Failed to save local data to local storage: \(error)")
        }
    }
    
    private func loadLocationDataFromLocalStorage() {
        let path = localFilePath(for: localDataFileName)
        guard FileManager.default.fileExists(atPath: path.path) else { return }
        
        let decoder = JSONDecoder()
        do {
            let data = try Data(contentsOf: path)
            location = try decoder.decode(LocationModel.self, from: data)
        } catch {
            print("Failed to load local data from local storage: \(error)")
        }
    }
}

//Extesion for async functions

extension LocationRepo {
   
    func getLocalEvents() async {
        let url = URL(string: "\(API_BASE_URL)/locals/\(self.location.id ?? "")/events_details")!
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        do {
            let (data, _) = try await URLSession.shared.data(for: request)
            let decoder = JSONDecoder()
            
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            let eventsInDB = try decoder.decode([EventModelInDB].self, from: data)
            
            let events_ = eventsInDB.map{event in
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
            
            self.events = events_// Using 'self' with 'mutating' method
            saveEventsToLocalStorage() // Save to local storage
        } catch {
            print("erro2")
        }
    }
}
