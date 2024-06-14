//
//  LocationModel.swift
//  BoJogar
//
//  Created by found on 11/06/24.
//

import Foundation
import CoreLocation

struct Location: Identifiable {
    let id = UUID()
    let name: String
    let coordinate: CLLocationCoordinate2D
}
