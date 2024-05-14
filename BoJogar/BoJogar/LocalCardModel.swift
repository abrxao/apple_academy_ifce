//
//  LocalCardModel.swift
//  BoJogar
//
//  Created by found on 30/04/24.
//

import Foundation
import SwiftUI

struct LocalCardModel: Codable {
    let id: Optional<String>
    var title: String // Change to var to allow mutation
    var imageURL: String

}


