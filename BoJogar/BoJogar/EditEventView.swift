//
//  EditEventView.swift
//  BoJogar
//
//  Created by found on 17/06/24.
//

import SwiftUI

struct EditEventView: View {
    @EnvironmentObject var userRepo: UserRepo
    @Environment(\.dismiss) var dismiss
    @State private var title = ""
    @State private var sport = "Crossfit"
    @State private var description = ""
    @State private var maxNumOfSubs: Int32?
    @State private var startDate: Date = Date.now // Configurar data e hora usando o formato de String
    @State private var endDate: Date = Date.now // Iso
    @State private var isLocationViewOpen = false
    @State var selectedPlace: PlaceModel?
    
    var body: some View {
        VStack{
            Rectangle()
                .frame(height: 1)
                .foregroundStyle(.gray)
            Spacer()
            VStack{
                Circle()
                    .stroke(.gray200)
                    .frame(width: 120)
                    .overlay(){
                        if(sport != ""){
                            Image(sport)
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .padding(16)
                                .frame(maxWidth: .infinity)
                                .foregroundStyle(.gray200)
                                .accessibilityLabel("Desenho representando o esporte  \(sport) ")
                        }
                        
                    }
                Form{
                    TextField("Titulo:",text:$title)
                        .autocorrectionDisabled(true)
                        .padding(.bottom)
                        .listRowBackground(Color.graySystem)
                    
                    TextField("Descrição:",text:$description)
                        .autocorrectionDisabled(true)
                        .padding(.bottom)
                        .listRowBackground(Color.graySystem)
                    
                    
                    Section{
                        Button{
                            isLocationViewOpen = true
                        }
                    label:{
                        
                        Text(selectedPlace?.name ?? "Localização:")
                            .frame(maxWidth: .infinity,alignment:.leading)
                        
                    }
                    .foregroundStyle(.black)
                    .listRowBackground(Color.graySystem)
                    }
                    Section{
                            TextField("Num. de participantes:", value: $maxNumOfSubs, formatter: NumberFormatter())
                                .listRowBackground(Color.graySystem)
                    }
                    
                    Section{
                        Picker("Esporte", selection: $sport){
                            ForEach(SPORTS, id: \.self){
                                Text("\($0) ").tag("\($0)")
                            }
                        }
                        .listRowBackground(Color.graySystem)
                    }
                    Section{
                        DatePicker("Data de Início ", selection: $startDate)
                            .listRowBackground(Color.graySystem)
                        
                        
                        DatePicker("Data de Término ", selection: $endDate)
                            .listRowBackground(Color.graySystem)
                        
                    }
                    
                }
                .scrollContentBackground(.hidden)
                
                Button("enviar"){
                    if (
                        sport != "" ||
                        title != "" ||
                        description != "" ||
                        startDate == endDate ||
                        selectedPlace != nil ||
                        userRepo.userId != ""
                    ){
                        
                        /*Task{
                         
                         try await userRepo.addEvent(
                         event:
                         EventModelRequest(creatorId: userRepo.userId,
                         title: title,
                         description: description,
                         startDate: startDate,
                         endDate: endDate,
                         sport: sport,
                         maxAttendees: maxNumOfSubs,
                         latitude: selectedPlace?.latitude ?? 0.0,
                         longitude: selectedPlace?.longitude ?? 0.0,
                         address: selectedPlace?.address ?? "",
                         localName: selectedPlace?.name ?? ""
                         ))
                         dismiss.callAsFunction()
                         }*/
                    }
                    else{
                        
                    }
                }
                .foregroundStyle(/*@START_MENU_TOKEN@*/.blue/*@END_MENU_TOKEN@*/)
                .padding(.vertical,8)
            }
        }
        .navigationTitle("Evento")
        .navigationBarTitleDisplayMode(.inline)
        .sheet(isPresented: $isLocationViewOpen){
            PlaceLookUpView(selectedPlace:$selectedPlace)
        }
        
        
    }
}

#Preview {
    EditEventView()
}
