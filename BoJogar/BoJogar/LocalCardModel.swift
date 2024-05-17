//
//  LocalCardModel.swift
//  BoJogar
//
//  Created by found on 30/04/24.
//

import Foundation
import SwiftUI

struct LocalCardModel: Codable, Identifiable, Hashable {
    let id: String
    var title: String // Change to var to allow mutation
    var imageURL: String
    //var mapsURL: Optional<String>
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
        hasher.combine(title)
        hasher.combine(imageURL)
    }
}
