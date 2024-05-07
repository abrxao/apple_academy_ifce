//
//  EventCardModel.swift
//  BoJogar
//
//  Created by found on 30/04/24.
//
import Foundation
import SwiftUI

struct EventCardModel: Codable {
    let id: UUID
    let title: String
    let subtitle: String
    let imageURL: String
}


