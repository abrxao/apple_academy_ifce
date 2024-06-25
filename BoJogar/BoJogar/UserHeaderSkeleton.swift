//
//  UserEventsSkeleton.swift
//  BoJogar
//
//  Created by found on 25/06/24.
//

import Foundation
import SwiftUI

struct UserHeaderSkeleton: View {
    
    var body: some View {
            VStack(alignment: .leading) {
                Spacer()
                    .frame(height: 40)
                    .frame(maxWidth: .infinity)
                SkeletonView()
                    .frame(width: 96, height: 32)
                    
                SkeletonView()
                    .frame(width: 256, height: 32)
                
                SkeletonView()
                    .frame(width: 160, height: 16)
            }
            .padding(.horizontal,20)
        }
}
