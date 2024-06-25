import SwiftUI

struct ImageURL: View {
    var url: URL
    var skeletonWidth: CGFloat?
    var skeletonHeight: CGFloat?
    var body: some View {
        AsyncImage(url: url) { phase in
            if let image = phase.image {
                image
                    .resizable()
                    .scaledToFill()
            } else if phase.error != nil {
                // Display a placeholder when loading failed
                Image(systemName: "questionmark.diamond")
                    .imageScale(.large)
            } else {
                // Display a placeholder while loading
                SkeletonView()
            }
        }
    }
}
