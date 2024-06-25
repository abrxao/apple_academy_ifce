//
//  Teste.swift
//  BoJogar
//
//  Created by found on 02/05/24.
//

import Foundation
import SwiftUI


struct SearchEventsView: View {
    @State private var events:[EventModel]=[]
    @State private var selectedEvent: EventModel?
    @State private var isLoadingEvents = false
    
    var body: some View {
        
        NavigationStack {
            ScrollView(.vertical, showsIndicators: false) {
                
                VStack{
                    HeaderView()
                        .background(.primaryBlue)
                    
                    VStack{
                        if(!isLoadingEvents){
                            if(events.isEmpty){
                                SectionTitle(text: "Sem eventos ainda")
                            }else{
                                SectionTitle(text: "Eventos próximos de você")
                                    .frame(maxWidth: .infinity,alignment:.leading)
                                
                                Spacer()
                                    .frame(height: 12)
                                VStack(alignment:.leading){
                                    ForEach(events, id: \.id) { event in // Iterate over items
                                        Button {
                                            selectedEvent = event
                                        } label: {
                                            EventCard(event: event)
                                            
                                        }
                                    }
                                }
                            }
                        }else{
                            EventsSkeleton()
                        }
                    }
                    .padding(.horizontal,20)
                    .padding(.vertical,32)
                    .frame(maxWidth: .infinity)
                    .background(.gray50)
                    .clipShape(UnevenRoundedRectangle(
                        topLeadingRadius: 32,
                        bottomLeadingRadius: 0,
                        bottomTrailingRadius: 0,
                        topTrailingRadius: 32,
                        style: .continuous))
                    .offset(y:-64)
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
                .offset(y:-64)
            }
            .background(.gray50)
        }
    }
    
    func getEvents() async {
        isLoadingEvents = true
        guard let url = URL(string: "\(API_BASE_URL)/events") else {
            print("Invalid URL")
            return
        }
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
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
            
            self.events = events_
        } catch {
            print(error)
        }
        isLoadingEvents = false
    }
    
}

