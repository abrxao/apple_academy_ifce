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
    @State private var opacity: Double = 0.8
    var width: CGFloat
    var height: CGFloat
    
    var body: some View {
        RoundedRectangle(cornerRadius: 0)
            .fill(Color.gray)
            .frame(maxWidth: width, maxHeight: height)
            .opacity(opacity)
            .onAppear {
                animateOpacity()
            }
    }
    
    private func animateOpacity() {
        withAnimation(Animation.easeInOut(duration: 1.5).repeatForever(autoreverses: true)) {
            self.opacity = 0.2
        }
    }
}

struct SkeletonView_Previews: PreviewProvider {
    static var previews: some View {
        SkeletonView(width: 100, height: 100)
    }
} 
