import Foundation
import SwiftUI

struct EventCard: View {
    let event: EventModel
    
    var body: some View {

        HStack(alignment: .center, spacing: 16){
            
            Image(event.sport)
                .resizable()
                .padding(8)
                .frame(maxWidth: 80, maxHeight:80)
                .scaledToFit()
                .accessibilityHidden(true)
                .background(.gray50)
                .cornerRadius(16)
                .shadow(color:.primaryBlue.opacity(0.6),radius: 2,y:4)
            
            VStack(alignment: .leading) {
                Text(event.title)
                    .multilineTextAlignment(.leading)
                    .lineLimit(1)
                    .fontWeight(.bold)
                    .foregroundStyle(.gray800)
                
                Text(event.description)
                    .font(.system(size:14))
                    .multilineTextAlignment(.leading)
                    .lineLimit(2, reservesSpace: true)
                    .foregroundStyle(.gray)
                
                Text(event.startDate.extractDateFormatted)
                    .font(.system(size:14))
                    .multilineTextAlignment(.leading)
                    .foregroundStyle(.gray)
                    .padding(.top,4)
                
            }
            .padding(.horizontal,4)
            
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.top,16)
        
        
    }
}
