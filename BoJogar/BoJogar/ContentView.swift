//
//  ContentView.swift
//  BoJogar
//
//  Created by found on 30/04/24.
//  http-server json javascript


import SwiftUI

// ContentView.swif
struct ContentView: View {
    
    var body: some View {
        
        ScrollView(showsIndicators: false) {
            Badge(text: "Locais Proximos")
                
            LocalCardView()
                .padding()
                .scrollClipDisabled(true)
            
            Spacer()
                .frame(height: 48)
            Badge(text: "Eventos Confirmados")
            Spacer()
                .frame(height: 32)
            EventCardView()
            
        }
        
    }
}

#Preview {
    ContentView()
}
