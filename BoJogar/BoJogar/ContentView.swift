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
            UserView()
                .tabItem {
                    Image(systemName: "house")
            }
            EventView()
                .tabItem { 
                    Image(systemName: "plus")
            }
            PerfilView()
                .tabItem {
                    Image(systemName: "person")
            }
            Text("Tab Content 2")
                .tabItem {
                    Image(systemName: "heart")
            }
        }
    }
}

#Preview {
    ContentView()
}
