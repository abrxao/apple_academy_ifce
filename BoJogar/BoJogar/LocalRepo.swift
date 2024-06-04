//
//  LocalsRepo.swift
//  BoJogar
//
//  Created by found on 14/05/24.
//

import Foundation
import SwiftUI

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
            
        } catch {
            print("erro2")
        }
    
    }

}

