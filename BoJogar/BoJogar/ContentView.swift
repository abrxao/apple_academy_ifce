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
            }.tag(1)
            Text("Tab Content 2")
                .tabItem { Image(systemName: "plus")
            }.tag(2)
            Text("Tab Content 1")
                .tabItem { Image(systemName: "heart")
            }.tag(3)
            Text("Tab Content 2")
                .tabItem { Image(systemName: "heart")
            }.tag(4)
        }
    }
}

#Preview {
    ContentView()
}
