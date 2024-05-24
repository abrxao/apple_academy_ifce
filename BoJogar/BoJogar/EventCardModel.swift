//
//  EventCardModel.swift
//  BoJogar
//
//  Created by found on 30/04/24.
//
import Foundation
import SwiftUI

struct EventCardModel:  Codable, Identifiable, Hashable  {
    var id: String
    var creatorId: String
    var title: String
    var description: String
    var startDate: String
    var endDate: String
    var imageURL: String
    var localID: String
    var subscribers: [String]
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
        hasher.combine(title)
        hasher.combine(creatorId)
    }
}


