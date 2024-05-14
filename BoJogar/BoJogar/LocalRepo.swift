//
//  LocalsRepo.swift
//  BoJogar
//
//  Created by found on 14/05/24.
//

import Foundation

struct LocalRepo {
    var events: [EventCardModel]
    var localData: LocalCardModel?
    var localID: String
    
    init(localID: String) {
        self.events = []
        self.localID = localID
    }
    
    mutating func deleteEventLocal(withId id: String) {
        events.removeAll { $0.id == id }
    }
}

extension LocalRepo {
    
    mutating func getLocal() async {
        guard let url = URL(string: "http://localhost:3001/locals/\(self.localID)") else {
            print("Invalid URL")
            return
        }
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            let decodedData = try decoder.decode(LocalCardModel.self, from: data)
            self.localData = decodedData
        } catch {
            print(error)
        }
    }
    
    mutating func getLocalEvents() async {

        guard let url = URL(string: "http://localhost:3001/locals/\(self.localID)/events_details") else {
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

}

