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
    
    var body: some View {
        VStack(alignment: .leading) {
            
            Text(local.name)
                .multilineTextAlignment(.leading)
                .lineLimit(2, reservesSpace: true)
                .foregroundStyle(.white)
                .padding(.horizontal, 8)
                .padding(.vertical, 6)
                .frame(maxWidth: .infinity, alignment: .leading)
            // Align text to the left
            
            Spacer()
                .frame(height: 12)
        }
        .containerRelativeFrame(.horizontal, count: 15, span: 7, spacing: 0,alignment: .topLeading)
        .background(.redSecondary) // Add background color to each item
        .cornerRadius(10) // Add corner radius to each item
        .shadow(radius: 2, y: 2.0) // Add shadow to each item
    }
}
