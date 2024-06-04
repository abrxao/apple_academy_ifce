import Foundation
import SwiftUI


struct EventSelected: View {
    
    let event: EventCardModel
    @State private var eventRepo: EventRepo
    @State private var selectedUser: UserModel?
    @State private var isCurrentUserSub: Bool
    @State private var userToRemove: UserModel?

    init(event: EventCardModel) {
        self.event = event
        _eventRepo = State(initialValue: EventRepo(event: event))
        _isCurrentUserSub = State(initialValue: event.subscribers.contains(USER_ID_TESTE))
        
    }
    
    var body: some View {
        ScrollView {
            VStack {
                //COMPONENTE DE IMAGE
                ZStack(alignment:.topLeading){
                    ImageURL(url: URL(string: event.imageURL)!,
                             skeletonWidth: .infinity,
                             skeletonHeight: .infinity
                    )
                        .frame(maxWidth: .infinity)
                        .aspectRatio(16/9, contentMode: .fill)
                        .clipped()
                    Badge(text:event.title,variation: "gray")
                        .padding()
                }
                .padding(.bottom)
                
                //COMPONENTE DE QUANTIDADE DE PARTICIPANTES
                VStack(alignment: .leading){
                    Text(event.title)
                        .font(.title)
                        .foregroundStyle(.red900)
                        .fontWeight(.semibold)
                        .padding(.bottom, 4)
                        
                    Spacer()
                        .frame(height: 1)
                        .frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/)
                        .background(.gray950)
                        .padding(.bottom)
                    
                    Text(event.description)
                        .padding(.bottom)
                    
                    HStack{
                        Text("\(Image(systemName: "location.fill"))")
                            .foregroundStyle(.redSecondary)
                            .font(.footnote)
                            
                        Text("Local: Quadra Aécio de Borba")
                            .font(.footnote)
                            .foregroundStyle(.gray700)
                    }
                    .padding(.bottom, 6)
                    
                    HStack{
                        Text("\(Image(systemName: "alarm.fill"))")
                            .foregroundStyle(.redSecondary)
                            .font(.footnote)
                        
                        Text("Data e Horário: \(event.startDate.extractDateFormatted)")
                            .font(.footnote)
                            .foregroundStyle(.gray700)
                    }
                    .padding(.bottom, 6)
                    if USER_ID_TESTE != event.creatorId {
                        //Botão de inscrição, caso o usuario que está na tela não seja o dono
                        HStack{
                            Spacer()
                                .frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/)
                            Button(isCurrentUserSub ? "Cancelar Inscrição" : "Inscrever-se") {
                                Task {
                                    do {
                                        try await eventRepo.toggleSubscribe(userID: USER_ID_TESTE)
                                        isCurrentUserSub = eventRepo.event.subscribers.contains(USER_ID_TESTE)
                                    } catch {
                                        print("Error: \(error)")
                                    }
                                }
                            }
                            .padding(.horizontal,8)
                            .padding(.vertical, 12)
                            .background(.red900)
                            .foregroundStyle(.white)
                            .cornerRadius(8)
                        }
                    }
                    
                    
                    Spacer()
                        .frame(height: 1)
                        .frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/)
                        .background(.gray700)
                        .padding(.bottom,2)
                        .padding(.top,8)
                    if(eventRepo.subscriberDetails.count > 0 ){
                        let numOfSubs = eventRepo.subscriberDetails.count
                        Text("\(numOfSubs) participante\(numOfSubs > 1 ? "s":"")")
                            .foregroundStyle(.red900)
                            .frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/)
                    }else{
                        Text("Sem participantes ainda")
                            .foregroundStyle(.red900)
                            .frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/)
                    }
                    Spacer()
                        .frame(height: 1)
                        .frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/)
                        .background(.gray700)
                        .padding(.bottom,8)
                        .padding(.top,1)
                }
                .padding(.horizontal, 16)
                
                //COMPONENTE DE AVATARES DE PARTICIPANTES
                ScrollView(.horizontal, showsIndicators: false){
                    HStack(spacing: 10) {
                        ForEach(eventRepo.subscriberDetails) { user in
                            ZStack(alignment:.topTrailing){
                                
                                Button {
                                    selectedUser = user
                                } label: {
                                    AvatarEventUser(imageURL: user.imageURL)
                                }
                                .accessibilityLabel("Participante: \(user.firstName) \(user.lastName)")
                                //Botão de remover usuario, caso o usuario que está na tela seja o dono do evento
                                if USER_ID_TESTE == event.creatorId {
                                    Button {
                                        userToRemove = user
                                    } label: {
                                        Text("\(.init(systemName: "minus"))")
                                            .padding(2)
                                    }
                                    .frame(width: 16,height: 16)
                                    .background(.redSecondary)
                                    .foregroundStyle(.white)
                                    .clipShape(/*@START_MENU_TOKEN@*/Circle()/*@END_MENU_TOKEN@*/)
                                    .accessibilityLabel("Remover participante \(user.firstName) \(user.lastName)")
                                    
                                }
                            }
                            
                        }
                    }
                    .alert(item: $userToRemove, content: { user in
                        Alert(
                            title: Text("Confirmar remoção"),
                            message: Text("Tem certeza que deseja remover \(user.firstName) \(user.lastName) do seu evento?"),
                            primaryButton: .destructive(Text("Remover")) {
                                // Perform the delete action here
                                // example action
                                Task{
                                    do{
                                        try await eventRepo.removeSubscriber(userID: user.id)
                                    }catch{
                                        print("nao removeu user")
                                    }
                                }
                            }
                            ,
                            secondaryButton: .cancel(Text("Cancelar"))
                        )
                    })
                    .padding()
                }  
            }
        }
        .task {
            await refreshSubscribersPeriodically()
        }
    }
    
    private func refreshSubscribersPeriodically() async {
        while !Task.isCancelled {
            await eventRepo.getSubscribersDetails()
            try? await Task.sleep(for: .seconds(5))
        }
    }
}
