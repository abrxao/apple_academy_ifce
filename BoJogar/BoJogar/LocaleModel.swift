//
//  LocalCardModel.swift
//  BoJogar
//
//  Created by found on 30/04/24.
//

import Foundation
import SwiftUI
import CoreLocation

struct LocationModel: Codable, Identifiable, Hashable {
    let id: String?
    var name: String // Change to var to allow mutation
    var latitude: Double
    var longitude: Double
    var address: String
    var coordinate: CLLocationCoordinate2D {
        CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }
    //var mapsURL: Optional<String>
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
        hasher.combine(name)
        hasher.combine(longitude)
    }
}

// criando branch toma 
