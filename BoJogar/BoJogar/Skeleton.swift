//
//  Skeleton.swift
//  BoJogar
//
//  Created by found on 03/05/24.
//

import Foundation
import SwiftUI

import SwiftUI

struct SkeletonView: View {
    @State private var opacity: Double = 0.6
    
    var body: some View {
        RoundedRectangle(cornerRadius: 4)
            .fill(.gray500)
            .opacity(opacity)
            .onAppear {
                animateOpacity()
            }
    }
    
    private func animateOpacity() {
        withAnimation(Animation.easeInOut(duration: 1).repeatForever(autoreverses: true)) {
            self.opacity = 0.2
        }
    }
}

struct SkeletonView_Previews: PreviewProvider {
    static var previews: some View {
        SkeletonView()
    }
} 
