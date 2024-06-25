import Foundation
import SwiftUI

struct EventSelected: View {
    
    let event: EventModel
    @State private var eventRepo: EventRepo
    @State private var selectedUser: UserModel?
    @State private var userToRemove: UserModel?
    @State private var locationData: LocationModel?
    @State private var isEditEventOpen = false
    
    init(event: EventModel) {
        self.event = event
        _eventRepo = State(initialValue: EventRepo(event: event))
    }
    
    var body: some View {
        ScrollView(showsIndicators: false) {
            ZStack(alignment: .topLeading){
                
                Image("courtBg")
                    .resizable()
                    .frame(maxWidth: .infinity)
                    .scaledToFit()
                    .accessibilityHidden(true)
                    .padding(.vertical, 64)
                    .background(.primaryBlue)
                    .offset(y:-108)
                
                //COMPONENTE DE QUANTIDADE DE PARTICIPANTES
                VStack{
                    Spacer()
                        .frame(height:144)
                    VStack(alignment: .leading){
                        HStack(alignment: .center){
                            SectionTitle(text: event.title)
                                .frame(maxWidth: .infinity,alignment:.leading)
                            if (USER_ID_TESTE == event.creatorId){
                                Button{
                                    isEditEventOpen = true
                                }label:{
                                    Text("\(Image(systemName: "pencil"))")
                                        .foregroundStyle(.primaryOrange)
                                        .font(.system(size:20))
                                        .foregroundStyle(.gray500)
                                }
                            }
                        }.padding(.top, 24)
                        Text(event.sport)
                            .font(.system(size:15))
                            .foregroundStyle(.primaryBlue)
                        
                        Text(event.description)
                            .padding(.vertical,16)
                            .foregroundStyle(.gray500)
                        
                        Spacer()
                            .frame(height: 1)
                            .frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/)
                            .background(.gray200)
                            .padding(.bottom)
                        
                        Button{
                            openMapWith(location:locationData!)
                        }label:{
                            
                            TextWithIcon(text: locationData?.name ?? "",
                                         icon: "location.fill",
                                         variation: "underline")
                            .padding(.bottom, 6)
                        }
                        
                        TextWithIcon(text: event.startDate.extractDateFormatted,
                                     icon: "alarm.fill")
                        .padding(.bottom, 6)
                        
                        if USER_ID_TESTE != event.creatorId {
                            //Botão de inscrição, caso o usuario que está na tela não seja o dono
                            
                            Button(eventRepo.event.subscribers.contains(USER_ID_TESTE) ? "Cancelar Inscrição" : "Inscrever-se") {
                                Task {
                                    do {
                                        try await eventRepo.toggleSubscribe(userID: USER_ID_TESTE)
                                        await eventRepo.getSubscribersDetails()
                                    } catch {
                                        print("Error: \(error)")
                                    }
                                }
                            }
                            .padding(.horizontal,32)
                            .padding(.vertical,8)
                            .fontWeight(.bold)
                            .background(.primaryOrange)
                            .foregroundStyle(.gray50)
                            .cornerRadius(.infinity)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical,32)
                        }
                        if(eventRepo.subscriberDetails.isEmpty){
                            SectionTitle(text: "Sem Participantes Ainda")
                                .padding(.top,16)
                            Text("Convide seus amigos")
                                .foregroundStyle(.gray700)
                            
                        } else{
                            SectionTitle(text: "Participantes")
                                .padding(.top,16)
                        }
                        
                    }
                    .padding(.horizontal, 16)
                    .background(.gray50)
                    .clipShape(UnevenRoundedRectangle(
                        topLeadingRadius: 16,
                        bottomLeadingRadius: 0,
                        bottomTrailingRadius: 0,
                        topTrailingRadius: 16,
                        style: .continuous))
                    ScrollView(.horizontal, showsIndicators: false){
                        HStack(spacing: 10) {
                            ForEach(eventRepo.subscriberDetails) { user in
                                ZStack(alignment:.topTrailing){
                                    
                                    Button {
                                        selectedUser = user
                                    } label: {
                                        VStack{
                                            AvatarEventUser(imageURL: user.imageURL)
                                            Text(user.firstName)
                                                .foregroundStyle(.gray700)
                                                .lineLimit(1)
                                                .frame(maxWidth: 64)
                                        }
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
                                        .foregroundStyle(.gray50)
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
                        .padding(.vertical,4)
                        .padding(.horizontal,16)
                    }
                }
            }
        }
        .navigationDestination(isPresented: $isEditEventOpen){
            EditEventView(eventToEdit: event,selectedPlace: locationData)
        }
        .background(.gray50)
        .task {
            await getLocationData()
            await refreshSubscribersPeriodically()
        }
    }
    private func getLocationData() async{
        let url = URL(string: "\(API_BASE_URL)/locals/\(self.event.localID)")!
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        do {
            let (data, _) = try await URLSession.shared.data(for:request)
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            let locationInDB = try decoder.decode(LocationInDB.self, from: data)
            self.locationData = LocationModel(id: locationInDB._id,
                                              name: locationInDB.name,
                                              latitude: locationInDB.location.coordinates[1],
                                              longitude: locationInDB.location.coordinates[0],
                                              address: locationInDB.address)
        } catch {
            print(error.localizedDescription)
        }
        
    }
    private func refreshSubscribersPeriodically() async {
        while !Task.isCancelled {
            await eventRepo.getSubscribersDetails()
            try? await Task.sleep(for: .seconds(2))
        }
    }
}
