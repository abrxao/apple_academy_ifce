//
//  EventCardModel.swift
//  BoJogar
//
//  Created by found on 30/04/24.
//
import Foundation
import SwiftUI

struct EventModelInDB: Codable{
    var _id: String
    var creatorId: String
    var title: String
    var description: String
    var startDate: String
    var endDate: String
    var sport: String
    var localID: String
    var maxAttendees: Int32
    var subscribers: [String]
}

struct EventModelRequest: Codable{
    var creatorId: String
    var title: String
    var description: String
    var startDate: String
    var endDate: String
    var sport: String
    var maxAttendees: Int
    var latitude: Double
    var longitude: Double
    var subscribers: [String]
    var address: String
    var localName: String
    var localID: String?
}

struct EventModel: Codable, Identifiable, Hashable  {
    var id: String?
    var creatorId: String
    var title: String
    var description: String
    var startDate: String
    var endDate: String
    var sport: String
    var maxAttendees: Int32
    var localID: String
    var subscribers: [String]
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
        hasher.combine(title)
        hasher.combine(creatorId)
    }
}


