import Foundation
import SwiftUI

var userId_teste = "3"

struct EventSelected: View {
    
    let event: EventCardModel
    
    @State private var eventRepo: EventRepo
    @State private var selectedUser: UserModel?
    @State private var isCurrentUserSub: Bool
    @State private var isRefreshing = false

    init(event: EventCardModel) {
        self.event = event
        self._eventRepo = State(initialValue: EventRepo(event: event))
        self._isCurrentUserSub = State(initialValue: event.subscribers.contains(userId_teste))
    }
    
    var body: some View {
        ScrollView {
            VStack {
                ImageURL(url: URL(string: event.imageURL)!,
                         skeletonWidth: UIScreen.main.bounds.width)
                    .frame(maxWidth: .infinity)
                    .aspectRatio(16/9, contentMode: .fill)
                    .clipped()
                
                VStack(alignment: .leading) {
                    Text(event.title)
                        .font(.title)
                        .fontWeight(.bold)
                        .padding(.bottom)
                    Text(event.description)
                        .font(.subheadline)
                        .fontWeight(.semibold)
                        .padding(.bottom)
                    Spacer()
                    Text("\(Image(systemName: "location.fill")) Local: Quadra Aécio de Borba")
                        .padding(.bottom)
                    Text("\(Image(systemName: "alarm.fill")) Data e Horário: 21/05 às 17:30")
                }
                .padding(.horizontal)
                
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 10) {
                        ForEach(eventRepo.subscriberDetails) { user in
                            Button {
                                selectedUser = user
                            } label: {
                                AvatarEventUser(imageURL: user.imageURL)
                            }
                        }
                    }
                    .padding()
                }
                
                Button(isCurrentUserSub ? "Cancelar Inscrição" : "Inscrever-se") {
                    Task {
                        do {
                            try await eventRepo.toggleSubscribe(userID: userId_teste)
                            isCurrentUserSub = eventRepo.event.subscribers.contains(userId_teste)
                        } catch {
                            print("Error: \(error)")
                        }
                    }
                }
                .padding()
                .background(Color.blue)
                .foregroundStyle(.white)
                .cornerRadius(8)
                .task {
                    await refreshSubscribersPeriodically()
                }
            }
        }
    }
    
    private func refreshSubscribersPeriodically() async {
        isRefreshing = true
        while isRefreshing {
            print("atualizou")
            await eventRepo.getSubscribersDetails()
            try? await Task.sleep(for: .seconds(5))
        }
    }
}
