//
//  EditEventView.swift
//  BoJogar
//
//  Created by found on 17/06/24.
//

import SwiftUI

let fiftheenMin = 60 * 15

struct EditEventView: View {
    @EnvironmentObject var userRepo: UserRepo
    @Environment(\.dismiss) var dismiss
    @State private var title: String
    @State private var sport: String
    @State private var description: String
    @State private var maxAttendees: Int
    @State private var startDate: Date
    @State private var endDate: Date // Adiciona 15 min na data incial
    @State private var isLocationViewOpen = false
    @State private var selectedPlace: LocationModel?
    
    let eventToEdit: EventModel?
    
    init(eventToEdit: EventModel?, selectedPlace: LocationModel?){
        self.eventToEdit = eventToEdit
        _title = State(initialValue: eventToEdit?.title ?? "")
        _sport =  State(initialValue: eventToEdit?.sport ?? "Ciclismo")
        _description =  State(initialValue: eventToEdit?.description ?? "")
        _maxAttendees = State(initialValue: Int(eventToEdit?.maxAttendees ?? 0))
        _startDate = State(initialValue: eventToEdit?.startDate.getDate ?? Date())
        _endDate = State(initialValue: eventToEdit?.endDate.getDate ?? Date())
        _selectedPlace = State(initialValue: selectedPlace)
    }

    var body: some View {
        VStack{
            Rectangle()
                .frame(height: 1)
                .foregroundStyle(.gray)
            Form{
                Circle()
                    .stroke(style: StrokeStyle(
                        lineWidth: 3,
                        lineCap: .round,
                        lineJoin: .round,
                        miterLimit: 0,
                        dash: [5, 10],
                        dashPhase: 0
                    ))
                    .foregroundStyle(.primaryOrange)
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
                    .frame(maxWidth: .infinity)
                
                TextField("Titulo:",text:$title)
                    .autocorrectionDisabled(true)
                    .listRowBackground(Color.graySystem)
                
                TextField("Descrição:",text:$description, axis: .vertical)
                    .autocorrectionDisabled(true)
                    .lineLimit(4...8)
                    .listRowBackground(Color.graySystem)
                
                Section{
                    Button{
                        isLocationViewOpen = true
                    }
                label:{
                    
                    Text(selectedPlace?.name ?? "Localização:")
                        .foregroundStyle(.gray950)
                        .frame(maxWidth: .infinity,alignment:.leading)
                    
                }
                .foregroundStyle(.gray800)
                .listRowBackground(Color.graySystem)
                }
                Section{
                    Picker("Num. de participantes:", selection: $maxAttendees){
                        ForEach(0..<100){
                            Text("\($0)")
                        }
                    }
                    .foregroundStyle(.gray950)
                    .frame(maxWidth: .infinity,alignment:.leading)
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
                Section {
                    DatePicker("Data de Início", selection: $startDate,in: Date()..., displayedComponents: [.date, .hourAndMinute])
                        .onChange(of: startDate) { newValue in
                            validateDates()
                        }
                        .listRowBackground(Color.graySystem)
                    
                    DatePicker("Hora de Término", selection: $endDate, in:startDate... , displayedComponents: .hourAndMinute)
                        .onChange(of: endDate) { newValue in
                            validateDates()
                        }
                        .listRowBackground(Color.graySystem)
                }
                
            }
            .scrollContentBackground(.hidden)
            
        }
        .toolbar{
            let isCreateEventAble = (
                title != "" &&
                description != "" &&
                selectedPlace != nil &&
                maxAttendees > 0
            )
            
            Button(eventToEdit == nil ? "Criar evento": "Salvar Edição"){
                if (isCreateEventAble){
                    
                    
                    let eventToRequest = EventModelRequest(creatorId: userRepo.userId,
                                                           title: title,
                                                           description: description,
                                                           startDate: startDate.ISO8601Format(),
                                                           endDate: endDate.ISO8601Format(),
                                                           sport: sport,
                                                           maxAttendees: maxAttendees,
                                                           latitude: selectedPlace?.latitude ?? 0.0,
                                                           longitude: selectedPlace?.longitude ?? 0.0,
                                                           subscribers: eventToEdit?.subscribers ?? [],
                                                           address: selectedPlace?.address ?? "",
                                                           localName: selectedPlace?.name ?? "")
                    
                    Task{
                        if(eventToEdit != nil ){
                            try await userRepo.editEvent(eventId: self.eventToEdit?.id ?? "", updatedEvent: eventToRequest)
                        } else {
                            try await userRepo.addEvent(event: eventToRequest)
                        }
                        dismiss.callAsFunction()
                    }
                }
            }
            .disabled(!isCreateEventAble)
            .opacity(!isCreateEventAble ? 0.5: 1)
            .foregroundStyle(.primaryBlue)
            .padding(.vertical,8)
        }
        .navigationTitle("Evento")
        .navigationBarTitleDisplayMode(.inline)
        .sheet(isPresented: $isLocationViewOpen){
            PlaceLookUpView(selectedPlace:$selectedPlace)
        }
    }
    func validateDates() {
        // Ensure end date is not before start date
        if endDate < startDate + 60 * 15 {
            endDate = startDate + 60 * 15
        }
        
        // Ensure both dates are on the same day
        let calendar = Calendar.current
        let startComponents = calendar.dateComponents([.year, .month, .day], from: startDate)
        let endComponents = calendar.dateComponents([.year, .month, .day], from: endDate)
        
        if startComponents != endComponents {
            endDate = startDate
        }
    }
}

