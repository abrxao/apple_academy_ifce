//
//  Teste.swift
//  BoJogar
//
//  Created by found on 02/05/24.
//

import Foundation
import SwiftUI


struct EventCardView: View {
    @State private var userEventsRepo = UserEventsRepo()
    
    var body: some View {
        
        VStack(spacing: 12) {
            Button("teste"){
                Task{
                    try await userEventsRepo.addEvent(
                        event:EventCardModel(
                            id:nil,
                            title: "title",
                            subtitle: "subtitle",
                            imageURL:"https://sportsjob.com.br/wp-content/uploads/2020/11/futebol.jpg"
                        ))
                }
            }
            ForEach(userEventsRepo.events, id: \.id) { event in // Iterate over items
                EventCard(event: event) // Render each item using ListItemView
            }
        }
        .padding()
        .task {
            await userEventsRepo.fetchEvents()
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
