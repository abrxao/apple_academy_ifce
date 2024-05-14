//
//  Teste.swift
//  BoJogar
//
//  Created by found on 02/05/24.
//

import Foundation
import SwiftUI


struct EventCardView: View {
    @State private var userEventsRepo = UserEventsRepo(userId: "1")
    var body: some View {
        
        VStack(spacing: 12) {
           
            ForEach(userEventsRepo.events, id: \.id) { event in // Iterate over items
                EventCard(event: event) // Render each item using ListItemView
            }
        }
        .padding()
        .task {
            await userEventsRepo.getUserEvents()
        }
        
        
    }

}

struct EventCard: View {
    let event: EventCardModel
    
    var body: some View {
        HStack {
            ImageURL(url: URL(string: event.imageURL)!,
                     width: 124,
                     height: 124)
            
            VStack(alignment: .leading) {
                Text(event.title)
                    .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                    .foregroundStyle(.white)
                Spacer()
                    .frame(height: 6)
                Text(event.description)
                    .font(.caption)
                    .foregroundStyle(.gray200)
                Spacer()
            }
            .padding(12)
            
            
            Spacer()
        }
        .background(.redSecondary)
        .cornerRadius(12)
        .shadow(radius: 2, y: 3.0)
    }
}
