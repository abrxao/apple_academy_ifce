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
        
        TabView( ) {
            Group{
                UserView()
                    .tabItem {
                        Label("Home", systemImage: "house")
                    }
                    
                EventView()
                    .badge(2)
                    .tabItem {
                        Label("Received", systemImage: "house")
                    }
                
                PerfilView()
                    .tabItem {
                        Label("Received", systemImage: "house")
                    }
                Text("Tab Content 2")
                    .tabItem {
                        Label("Received", systemImage: "house")
                    }
            }
            .toolbarBackground(.black, for: .tabBar)
            .toolbarBackground(.visible, for: .tabBar)
            .accentColor(Color("redSecondary"))
            
        }
        
    }
}

#Preview {
    ContentView()
}
