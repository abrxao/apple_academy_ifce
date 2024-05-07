//
//  Teste.swift
//  BoJogar
//
//  Created by found on 02/05/24.
//

import Foundation
import SwiftUI


struct EventCardView: View {
    @State private var events: [EventCardModel] = []
    
    var body: some View {
        
        VStack(spacing: 12) {
            ForEach(events, id: \.id) { event in // Iterate over items
                EventCard(event: event) // Render each item using ListItemView
            }
        }
        .padding()
        .task{
            await fetchEvents()
        }
    }

    func fetchEvents() async {
        guard let url = URL(string: "http://localhost:3001/events") else {
            print("Invalid URL")
            return
        }
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            let decodedData = try decoder.decode([EventCardModel].self, from: data)
            self.events = decodedData
        } catch {
            print(error)
        }
    }
}

struct EventCard: View {
    let event: EventCardModel
    
    var body: some View {
        HStack {
            ImageURL(url: URL(string: event.imageURL)!,
                     width: 124,
                     heigth: 124)
            
            VStack(alignment: .leading) {
                Text(event.title)
                Text(event.subtitle)
                Spacer()
            }
            .padding(12)
            
            Spacer()
        }
        .background(Color.white)
        .cornerRadius(12)
        .shadow(radius: 2, y: 3.0)
    }
}
