//
//  Teste.swift
//  BoJogar
//
//  Created by found on 02/05/24.
//

import Foundation
import SwiftUI


struct SearchEventsView: View {
    @State private var events:[EventModel] = []
    @State private var selectedEvent: EventModel?
    
    var body: some View {
        
        NavigationStack {
            ScrollView(.vertical, showsIndicators: false) {
                Spacer()
                    .frame(maxWidth: 32)
                VStack{
                    if(events.isEmpty){
                        SectionTitle(text: "Sem eventos ainda")
                    }else{
                        SectionTitle(text: "Eventos próximos de você")
                            .padding(.bottom,24)
                        
                        Spacer()
                            .frame(height: 12)
                        VStack(alignment:.leading,spacing:16){
                            ForEach(events, id: \.id) { event in // Iterate over items
                                Button {
                                    selectedEvent = event
                                } label: {
                                    EventCard(event: event)
                                    
                                }
                            }
                        }
                    }
                }
                .navigationDestination(item: $selectedEvent, destination: { event in
                    EventSelected(event: event)
                })
                .navigationTitle("Eventos")
                .navigationBarTitleDisplayMode(.inline)
                .navigationBarHidden(true)
                .padding(.horizontal,20)
                .task {
                    await getEvents()
                }
            }
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
            let decodedData = try decoder.decode([EventModel].self, from: data)
            self.events = decodedData
        } catch {
            print(error)
        }
    }
    
}

