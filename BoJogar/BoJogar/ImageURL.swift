import SwiftUI

struct ImageURL: View {
    var url: URL
    var width: Float32?
    var heigth: Float32?

    var body: some View {
        AsyncImage(url: url) { phase in
            if let image = phase.image {
                // Display the loaded image
                image
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: CGFloat(width ?? 174),
                           height: CGFloat(heigth ?? 174))
                    .clipped()
            } else if phase.error != nil {
                // Display a placeholder when loading failed
                Image(systemName: "questionmark.diamond")
                    .imageScale(.large)
            } else {
                // Display a placeholder while loading
                SkeletonView(width: CGFloat(width ?? 174),
                             height: CGFloat(width ?? 174))
            }
        }
    }
}
