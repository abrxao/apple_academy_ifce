//
//  UserEventsView.swift
//  BoJogar
//
//  Created by found on 18/06/24.
//

import Foundation
import SwiftUI

struct UserEventsView: View {
    @EnvironmentObject var userRepo: UserRepo
    @State private var selectedEvent: EventModel?
    @State private var isEditEventOpen = false
    
    var body: some View {
        
        VStack(alignment: .leading, spacing: 8) {
            
            if(!userRepo.isLoadingEvents){
                if(userRepo.events.isEmpty){
                    SectionTitle(text: "Sem eventos ainda")
                        .multilineTextAlignment(.center)
                        .frame(maxWidth: .infinity)
                    Button{
                        isEditEventOpen = true
                    }label:{
                        Text("Novo Evento")
                            .font(.system(size: 14))
                            .padding(.top,12)
                            .multilineTextAlignment(.center)
                            .frame(maxWidth: .infinity)
                    }
                    
                }
                else{
                    let allEvents = userRepo.events.count
                    let numOfUserEvents = userRepo.numOfUserEvents
                    
                    if(numOfUserEvents != 0){
                        HStack{
                            SectionTitle(text: "Seus Eventos")
                                .frame(maxWidth: .infinity, alignment:.leading)
                            Button{
                                isEditEventOpen = true
                            }label:{
                                Text("Novo Evento")
                                    .font(.system(size: 14))
                            }
                        }
                        
                        Spacer()
                            .frame(height: 1)
                        
                        ForEach(userRepo.events, id: \.id) { event in // Iterate over items
                            if (event.creatorId == USER_ID_TESTE){
                                Button {
                                    selectedEvent = event
                                } label: {
                                    EventCard(event: event)
                                }
                            }
                        }
                        Spacer()
                            .frame(height: 24)
                        
                    }
                    
                    if( allEvents - numOfUserEvents != 0){
                        HStack{
                            SectionTitle(text: "Eventos Inscritos")
                                .frame(maxWidth: .infinity,alignment: .leading)
                            
                            if (allEvents - numOfUserEvents == allEvents){
                                Button{
                                    isEditEventOpen = true
                                }label:{
                                    Text("Novo Evento")
                                        .font(.system(size: 14))
                                }
                            }
                        }
                        Spacer()
                            .frame(height: 1)
                        
                        ForEach(userRepo.events, id: \.id) { event in // Iterate over items
                            if (event.creatorId != USER_ID_TESTE){
                                Button {
                                    selectedEvent = event
                                } label: {
                                    EventCard(event: event)
                                }
                            }
                        }
                    }
                }
            }else{
                EventsSkeleton()
            }
        }
        .navigationDestination(item: $selectedEvent, destination: { event in
            EventSelected(event: event)
        })
        .navigationDestination(isPresented: $isEditEventOpen){
            EditEventView(eventToEdit: nil,selectedPlace: nil)
        }
        .navigationBarTitleDisplayMode(.inline)
        .navigationTitle("Voltar")
        .navigationBarHidden(true)
        .frame(maxWidth: .infinity)
        .task {
            await userRepo.getUserEvents()
        }
    }
}
