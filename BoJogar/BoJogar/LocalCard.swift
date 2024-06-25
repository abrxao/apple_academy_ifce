//
//  local-card.swift
//  BoJogar
//
//  Created by found on 30/04/24.
//

import Foundation
import SwiftUI

struct LocalCard: View {
    let local: LocationModel
    let distance: String?
    
    var body: some View {
        VStack(alignment: .leading) {

            Text(local.name)
                .multilineTextAlignment(.leading)
                .lineLimit(2, reservesSpace: true)
                .foregroundStyle(.gray50)
                .frame(maxWidth: .infinity, alignment: .leading)
                .fontWeight(.semibold)
            // Align text to the left
            Text(distance ?? "")
                .font(.callout)
                .foregroundStyle(.gray200)
                .frame(maxWidth: .infinity, alignment: .trailing)
            
            Spacer()
                .frame(height: 12)
        }
        .padding(.horizontal,16)
        .padding(.vertical,12)
        .background(.primaryBlue) // Add background color to each item
        .cornerRadius(10) // Add corner radius to each item
        .shadow(radius: 2, y: 2.0) // Add shadow to each item
    }
}
