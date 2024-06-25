import Foundation
import SwiftUI

struct TextWithIcon: View {
    let text: String // Changed Optional<String> to String?
    let icon: String
    var variation: String? = nil
    
    var body: some View {
        HStack{
            Text("\(Image(systemName: icon))")
                .foregroundStyle(.primaryOrange)
                .font(.system(size:15))
                .foregroundStyle(.gray500)
            
            if (variation == "underline"){
                Text(text)
                    .font(.system(size:15))
                    .foregroundStyle(.gray500)
                    .underline()
            }else{
                Text(text)
                    .font(.system(size:15))
                    .foregroundStyle(.gray500)
            }
        }
    }
}
