import Foundation
import SwiftUI

struct LocalRepo {
    var events: [EventCardModel]
    var localData: LocalCardModel?
    var localID: String
    private let eventsFileName: String
    private let localDataFileName: String
    
    init(localID: String) {
        self.events = []
        self.localID = localID
        self.eventsFileName = "events_\(localID).json"
        self.localDataFileName = "localData_\(localID).json"
        loadEventsFromLocalStorage()
        loadLocalDataFromLocalStorage()
    }
    
    mutating func deleteEventLocal(withId id: String) {
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
    
    private mutating func loadEventsFromLocalStorage() {
        let path = localFilePath(for: eventsFileName)
        guard FileManager.default.fileExists(atPath: path.path) else { return }
        
        let decoder = JSONDecoder()
        do {
            let data = try Data(contentsOf: path)
            events = try decoder.decode([EventCardModel].self, from: data)
        } catch {
            print("Failed to load events from local storage: \(error)")
        }
    }
    
    private func saveLocalDataToLocalStorage() {
        let encoder = JSONEncoder()
        do {
            let data = try encoder.encode(localData)
            try data.write(to: localFilePath(for: localDataFileName))
        } catch {
            print("Failed to save local data to local storage: \(error)")
        }
    }
    
    private mutating func loadLocalDataFromLocalStorage() {
        let path = localFilePath(for: localDataFileName)
        guard FileManager.default.fileExists(atPath: path.path) else { return }
        
        let decoder = JSONDecoder()
        do {
            let data = try Data(contentsOf: path)
            localData = try decoder.decode(LocalCardModel.self, from: data)
        } catch {
            print("Failed to load local data from local storage: \(error)")
        }
    }
}

extension LocalRepo {
    mutating func getLocal() async {
        let url = URL(string: "\(API_BASE_URL)/locals/\(self.localID)")!
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("true", forHTTPHeaderField: "ngrok-skip-browser-warning")
        do {
            let (data, _) = try await URLSession.shared.data(for: request)
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            let decodedData = try decoder.decode(LocalCardModel.self, from: data)
            self.localData = decodedData
            saveLocalDataToLocalStorage() // Save to local storage
        } catch {
            print(error)
        }
    }
    
    mutating func getLocalEvents() async {
        let url = URL(string: "\(API_BASE_URL)/locals/\(self.localID)/events_details")!
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("true", forHTTPHeaderField: "ngrok-skip-browser-warning")
        do {
            let (data, _) = try await URLSession.shared.data(for: request)
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            let decodedData = try decoder.decode([EventCardModel].self, from: data)
            self.events = decodedData // Using 'self' with 'mutating' method
            saveEventsToLocalStorage() // Save to local storage
        } catch {
            print("erro2")
        }
    }
}
