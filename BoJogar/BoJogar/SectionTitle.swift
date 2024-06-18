import Foundation
import SwiftUI

struct SectionTitle: View {
    let text: String // Changed Optional<String> to String?
    var variation: String?
    
    var body: some View {
        Text(text)
            .fontWeight(.bold)
            .font(.system(size:24))
            .foregroundStyle(.gray800)
        
    }
}
