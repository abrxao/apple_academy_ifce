import Foundation
import SwiftUI


struct EventUserCardView: View {
    @State private var userEventsRepo = UserEventsRepo(userId: USER_ID_TESTE)
    @State private var selectedEvent: EventCardModel?
    var body: some View {
        ZStack(alignment:.topTrailing){
            Button{
                print("teste")
            }
            label:{
                Text("Novo Evento")
                    .font(.system(size: 14))
                    .padding(.top,12)
            }
            VStack(alignment: .leading,spacing: 8) {
                if(userEventsRepo.events.isEmpty){
                    SectionTitle(text: "Sem eventos ainda")
                        .multilineTextAlignment(.center)
                }else{
                    if(userEventsRepo.numOfUserEvents != 0){
                        SectionTitle(text: "Seus Eventos")
                            .multilineTextAlignment(.leading)
                        Spacer()
                            .frame(height: 1)
                        
                        ForEach(userEventsRepo.events, id: \.id) { event in // Iterate over items
                            if (event.creatorId == USER_ID_TESTE){
                                Button {
                                    selectedEvent = event
                                } label: {
                                    EventUserCard(event: event)
                                }
                            }
                        }
                    }
                    
                    
                    
                    if( userEventsRepo.events.count - userEventsRepo.numOfUserEvents != 0){
                        SectionTitle(text: "Eventos Inscritos")
                            .multilineTextAlignment(.leading)
                            .padding(.top, 24)
                        Spacer()
                            .frame(height: 1)
                        
                        ForEach(userEventsRepo.events, id: \.id) { event in // Iterate over items
                            if (event.creatorId != USER_ID_TESTE){
                                Button {
                                    selectedEvent = event
                                } label: {
                                    EventUserCard(event: event)
                                }
                            }
                        }
                    }
                }
            }
        }
        .navigationDestination(item: $selectedEvent, destination: { event in
            EventSelected(event: event)
        })
        .navigationBarTitleDisplayMode(.inline)
        .navigationTitle("Voltar")
        .navigationBarHidden(true)
        .frame(maxWidth: .infinity)
        .task {
            await userEventsRepo.getUserEvents()
        }
        
    }

}

struct EventUserCard: View {
    let event: EventCardModel
    
    
    var body: some View {
            HStack {
                ImageURL(url: URL(string: event.imageURL)!)
                    .frame(maxWidth: 96, maxHeight:96)
                    .clipped()
                
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
            .cornerRadius(16)
            
        }
}
