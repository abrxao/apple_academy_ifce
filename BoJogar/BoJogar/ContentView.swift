//
//  ContentView.swift
//  BoJogar
//
//  Created by found on 07/05/24.
//

import Foundation
import SwiftUI

struct ContentView: View {
    @EnvironmentObject var locationManager: LocationManager
    
    var body: some View {
       
        TabView {
            Group {
                NavigationStack {
                    VStack{
                        Text("\(locationManager.location?.coordinate.latitude ?? 0.0)")
                        UserView()
                    }
                    
                }
                .tabItem {
                    Label("Home", systemImage: "house")
                }
                
                NavigationStack {
                    NearbyEventsView()
                }
                .tabItem {
                    Label("Eventos", systemImage: "sportscourt")
                        
                }
                PlaceLookUpView()
                    .environmentObject(locationManager)
                    .tabItem {
                        Label("Read", systemImage: "house")
                    }
            }
            .toolbarBackground(.gray950, for: .tabBar)
            .toolbarBackground(.visible, for: .tabBar)
        }
        .accentColor(.redSecondary)
        
        
    }
    
}

#Preview {
    ContentView()
        .environmentObject(LocationManager())
}
