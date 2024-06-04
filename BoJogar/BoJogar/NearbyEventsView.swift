//
//  NearbyEventsView.swift
//  BoJogar
//
//  Created by found on 28/05/24.
//

import Foundation
import SwiftUI

struct NearbyEventsView: View {
    
    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            Spacer()
                .frame(maxWidth: 32)
            EventCardView()
            
            
        }
    }
}
