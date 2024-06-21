import Foundation
import SwiftUI

struct EventCard: View {
    let event: EventModel
    
    var body: some View {
        HStack {
            Image(event.sport)
                .resizable()
                .padding(8)
                .frame(maxWidth: 96, maxHeight:96)
                .scaledToFit()
                
            
            VStack(alignment: .leading) {
                Text(event.title)
                    .multilineTextAlignment(.leading)
                    .lineLimit(1)
                    .fontWeight(.bold)
                    .foregroundStyle(.gray800)
                Spacer()
                    .frame(height: 6)
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
                Spacer()
                    .frame(maxHeight:.infinity)
                
            }
            .padding(.horizontal,4)
            
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .cornerRadius(16)
        
    }
}
