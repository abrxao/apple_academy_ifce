import SwiftUI

struct ImageURL: View {
    var url: URL
    var width: Float32?
    var height: Float32?

    var body: some View {
        AsyncImage(url: url) { phase in
            if let image = phase.image {
                // Display the loaded image
                image
                    .resizable()
            } else if phase.error != nil {
                // Display a placeholder when loading failed
                Image(systemName: "questionmark.diamond")
                    .imageScale(.large)
            } else {
                // Display a placeholder while loading
                SkeletonView(width: CGFloat(width ?? 174),height: CGFloat(height ?? 174))
                    .frame(maxWidth: CGFloat(width ?? /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/))
            }
        }
    }
}
