import Foundation
import SwiftUI

struct Badge: View {
    let text: String // Changed Optional<String> to String?
    var variation: String?
    
    var body: some View {
        Text(text)
            .padding(.horizontal, 8)
            .padding(.vertical, 4)
            .foregroundStyle(.white)
            .background(.redSecondary) // Fixed the background syntax
            .cornerRadius(8)
            .shadow(radius: 2, y: 2.0)
    }
}
