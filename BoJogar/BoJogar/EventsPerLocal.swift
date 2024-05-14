//
//  NearbyEventsView.swift
//  BoJogar
//
//  Created by found on 14/05/24.
//

import Foundation
import SwiftUI

 

struct EventsPerLocal: View {
    @State private var localRepo = LocalRepo(localID: "1")
    var body: some View{
        ScrollView(showsIndicators: false) {
            if (localRepo.localData != nil){
                ImageURL(url: URL(string: localRepo.localData?.imageURL ?? "")!,
                         width: .infinity,
                         height: 250)
                
                Text(localRepo.localData?.title ?? "Evento")
                    .font(/*@START_MENU_TOKEN@*/.title/*@END_MENU_TOKEN@*/)
                    .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                    
            }
            
            
        }
        .task{
            await localRepo.getLocal()
        }
        
        
    }
}

#Preview {
    EventsPerLocal()
}
