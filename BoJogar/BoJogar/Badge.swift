//
//  badge.swift
//  BoJogar
//
//  Created by found on 30/04/24.
//

import Foundation
import SwiftUI

struct Badge: View {
    let text: String
    var body: some View{
        Text(text)
            .padding(.horizontal, 8)
            .padding(.vertical, 4)
            .foregroundStyle(.white)
            .background(.black)
            .cornerRadius(8)
            .shadow(radius: 2, y: 2.0)
    }
}
