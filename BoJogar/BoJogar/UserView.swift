//
//  ContentView.swift
//  BoJogar
//
//  Created by found on 30/04/24.
//  http-server json javascript

import SwiftUI

// ContentView.swif
struct UserView: View {
    var body: some View {
        ScrollView(showsIndicators: false) {
            Spacer()
                .frame(height: 4)
            
            Badge(text: "Locais Proximos")
            
            LocalCardView()
                .padding()
                .scrollClipDisabled(true)
            
            Spacer()
                .frame(height: 40)
            Badge(text: "Eventos Confirmados")
        
            Spacer()
                .frame(height: 12)
            EventCardView()
            
        }
    }
}

#Preview {
    UserView()
}
