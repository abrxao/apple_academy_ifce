//
//  ContentView.swift
//  BoJogar
//
//  Created by found on 07/05/24.
//

import Foundation
import SwiftUI

struct ContentView: View {
    var body: some View {
        
        TabView {
            Group {
                NavigationStack {
                    UserView()
                }
                .tabItem {
                    Label("Home", systemImage: "house")
                }
                
                SearchEventsView()
                    .tabItem {
                        Label("Eventos", systemImage: "sportscourt")
                    }
                
                LocationsView()
                    .tabItem {
                        Label("Locais", systemImage: "map")
                    }
            }
            .toolbarBackground(.gray50, for: .tabBar)
            .toolbarBackground(.visible, for: .tabBar)
        }
        .accentColor(.primaryOrange)
        
        
    }
    
}

#Preview {
    ContentView()
        .environmentObject(LocationManager())
}
