//
//  BoJogarApp.swift
//  BoJogar
//
//  Created by found on 30/04/24.
//

import SwiftUI

@main
struct BoJogarApp: App {
    @StateObject private var locationManager = LocationManager() 
    @StateObject private var userRepo = UserRepo(userId: USER_ID_TESTE)
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(locationManager)
                .environmentObject(userRepo)
        }
    }
}

