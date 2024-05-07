//
//  EventCardModel.swift
//  BoJogar
//
//  Created by found on 30/04/24.
//
import Foundation
import SwiftUI

struct EventCardModel: Codable {
    let id = UUID()
    var title: String

    var subtitle: String
    var imageURL: String
}


