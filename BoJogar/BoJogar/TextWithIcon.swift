import Foundation
import SwiftUI

struct TextWithIcon: View {
    let text: String // Changed Optional<String> to String?
    var icon: String
    
    var body: some View {
        HStack{
            Text("\(Image(systemName: icon))")
                .foregroundStyle(.primaryOrange)
                .font(.system(size:15))
                .foregroundStyle(.gray500)
            
            Text(text)
                .font(.system(size:15))
                .foregroundStyle(.gray500)
        }
        
    }
}
