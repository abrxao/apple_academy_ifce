//
//  Teste.swift
//  BoJogar
//
//  Created by found on 02/05/24.
//

import Foundation
import SwiftUI


struct EventUserCardView: View {
    @State private var userEventsRepo = UserEventsRepo(userId: USER_ID_TESTE)
    @State private var selectedEvent: EventCardModel?
    var body: some View {
        VStack(spacing: 12) {
            if(userEventsRepo.events.isEmpty){
                Badge(text: "Sem eventos ainda")
            }else{
                Badge(text: "Eventos Confirmados")
                
                Spacer()
                    .frame(height: 12)
                
                ForEach(userEventsRepo.events, id: \.id) { event in // Iterate over items
                    Button {
                       selectedEvent = event
                    } label: {
                        EventUserCard(event: event)
                    }
                }
            }
        }
        .navigationDestination(item: $selectedEvent, destination: { event in
            EventSelected(event: event)
        })
        .navigationBarTitleDisplayMode(.inline)
        .navigationTitle("Voltar")
        .navigationBarHidden(true)
        .padding()
        .task {
            await userEventsRepo.getUserEvents()
        }
        
        
    }

}

struct EventUserCard: View {
    let event: EventCardModel
    
    var body: some View {
        ZStack(alignment:.bottomTrailing){
            HStack {
                ImageURL(url: URL(string: event.imageURL)!)
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 124, height: 124)
                    .clipped()
                
                VStack(alignment: .leading) {
                    Text(event.title)
                        .multilineTextAlignment(.leading)
                        .lineLimit(1)
                        .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                        .foregroundStyle(.white)
                    Spacer()
                        .frame(height: 6)
                    Text(event.description)
                        .multilineTextAlignment(.leading)
                        .lineLimit(3, reservesSpace: true)
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
            if event.creatorId == USER_ID_TESTE {
                Badge(text: "Seu Evento")
                    .font(.caption)
                    .padding(4)
            }
        }
    }
}
