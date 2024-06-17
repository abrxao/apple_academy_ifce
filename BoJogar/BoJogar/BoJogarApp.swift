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
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(locationManager)
        }
    }
}

