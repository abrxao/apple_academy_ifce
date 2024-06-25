//
//  UserHeaderSkeleton.swift
//  BoJogar
//
//  Created by found on 25/06/24.
//

import Foundation
import SwiftUI

struct EventsSkeleton: View {
    
    var body: some View {
        VStack(alignment: .leading,spacing: 16){
            SkeletonView()
                .frame(width: 128,height: 32)
                .padding(.top,16)
            
            SkeletonView()
                .frame(maxWidth: .infinity)
                .frame(height: 96)
            
            SkeletonView()
                .frame(maxWidth: .infinity)
                .frame(height: 96)
            
            SkeletonView()
                .frame(maxWidth: .infinity)
                .frame(height: 96)
            
            SkeletonView()
                .frame(maxWidth: .infinity)
                .frame(height: 96)
            
        }
    }
}

