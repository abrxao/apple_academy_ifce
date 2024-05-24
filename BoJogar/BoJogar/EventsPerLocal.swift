//
//  NearbyEventsView.swift
//  BoJogar
//
//  Created by found on 14/05/24.
//

import Foundation
import SwiftUI

 

struct EventsPerLocal: View {
    
    @State private var localRepo: LocalRepo
    
    init(localID: String) {
        self._localRepo = State(initialValue: LocalRepo(localID: localID))
    }
    
    var body: some View{
        
        ScrollView(showsIndicators: false) {
            if (localRepo.localData != nil){
                ImageURL(url: URL(string: localRepo.localData?.imageURL ?? "")!, skeletonWidth: UIScreen.main.bounds.width)
                    .frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/)
                    .aspectRatio(16/9,contentMode: .fit)
                    .clipped()
                VStack(alignment:.leading){
                    Text(localRepo.localData?.title ?? "Evento")
                        .font(/*@START_MENU_TOKEN@*/.title/*@END_MENU_TOKEN@*/)
                        .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                        .foregroundStyle(.red900)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    Spacer()
                        .frame(maxWidth: .infinity)
                        .frame(height: 1)
                        .background(.gray200)
                    Spacer()
                        .frame(height: 20)
                        
                    
                    HStack(alignment:.center){
                        Image(systemName: "location.fill")
                            .foregroundStyle(.redSecondary)
                        Text("Av. Senador Fernandes Távora, 1441 - Jóquei Clube, Fortaleza - CE, 60510-111")
                            
                    }
                    Spacer()
                        .frame(height: 16)
                    HStack(alignment:.center){
                        Image(systemName: "map.fill")
                            .foregroundStyle(.redSecondary)
                        Text("5 Km de você")
                            
                    }
                    
                }.padding(.horizontal,16)
                
                Spacer()
                    .frame(height: 36)
                
                Badge(text:"Eventos cadastrados")
                VStack(spacing: 12) {
                    ForEach(localRepo.events, id: \.id) { event in // Iterate over items
                        EventCard(event: event) // Render each item using ListItemView
                    }
                }
                .padding()
               
            } else {
                ProgressView()
            }
            
        }
        .task {
            await localRepo.getLocal()
            await localRepo.getLocalEvents()
        }
        
        
    }
        
}
