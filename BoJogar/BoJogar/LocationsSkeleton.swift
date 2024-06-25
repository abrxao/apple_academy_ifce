//
//  UserHeaderSkeleton.swift
//  BoJogar
//
//  Created by found on 25/06/24.
//

import Foundation
import SwiftUI

struct LocationsSkeleton: View {
    let columns = [
        GridItem(.flexible(minimum: 100, maximum: 240)),
        GridItem(.flexible(minimum: 100, maximum: 240))
    ]
    
    var body: some View {
        SkeletonView()
            .frame(width: 128,height: 32)
            .padding(.vertical,16)
        
        LazyVGrid(columns: columns, spacing: 20) {
            
            SkeletonView()
                .frame(height: 96)
            SkeletonView()
                .frame(height: 96)
            SkeletonView()
                .frame(height: 96)
            SkeletonView()
                .frame(height: 96)
            SkeletonView()
                .frame(height: 96)
            SkeletonView()
                .frame(height: 96)
        }
    }
}

