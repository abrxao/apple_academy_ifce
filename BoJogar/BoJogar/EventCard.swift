//
//  Teste.swift
//  BoJogar
//
//  Created by found on 02/05/24.
//

import Foundation
import SwiftUI


struct EventCardView: View {
    @State private var events:[EventCardModel] = []
    @State private var selectedEvent: EventCardModel?
    var body: some View {
        VStack{
            if(events.isEmpty){
                SectionTitle(text: "Sem eventos ainda")
            }else{
                SectionTitle(text: "Eventos próximos de você")
                    .padding(.bottom,24)
                
                Spacer()
                    .frame(height: 12)
                VStack(spacing:16){
                    ForEach(events, id: \.id) { event in // Iterate over items
                        Button {
                            selectedEvent = event
                        } label: {
                            EventCard(event: event)
                        }
                    }
                }
                Spacer()
                    .frame(maxHeight: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/)
            }
        }
        .navigationDestination(item: $selectedEvent, destination: { event in
            EventSelected(event: event)
        })
        .navigationTitle("Eventos")
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarHidden(true)        
        .task {
            await getEvents()
        }
        
    }
    
    func getEvents() async {
        guard let url = URL(string: "\(API_BASE_URL)/events") else {
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
        VStack(alignment: .leading) {
            ImageURL(url: URL(string: event.imageURL)!)
                .frame( maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/,maxHeight: 170)
                .aspectRatio(contentMode: .fill)
                .clipped()
            
            Text(event.title)
                .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                .foregroundStyle(.white)
                .padding(.horizontal,16)
            
            Text(event.description)
                .font(.caption)
                .foregroundStyle(.gray200)
                .padding(.horizontal,16)
                .padding(.bottom,32)
                .multilineTextAlignment(/*@START_MENU_TOKEN@*/.leading/*@END_MENU_TOKEN@*/)
                
        }
        .background(.redSecondary)
        .cornerRadius(12)
        .shadow(radius: 2, y: 3.0)
        
    }
}
