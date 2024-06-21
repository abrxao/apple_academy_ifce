//
//  EditEventView.swift
//  BoJogar
//
//  Created by found on 17/06/24.
//

import SwiftUI

struct EditEventView: View {
    
    @Environment(\.dismiss) var dismiss
    @State private var title = ""
    @State private var location = ""
    @State private var description = ""
    @State private var sport = "Badminton"
    @State private var peopleNumber = 0
    @State private var detalhes = false
    @State private var startDate: Date = Date()
    @State private var endDate: Date = Date()

    
    var body: some View {
        
        NavigationStack{
            VStack{
                Rectangle()
                    .frame(height: 1)
                    .foregroundStyle(.gray)
                Spacer()
                VStack{
                    Circle()
                        .stroke(Color.primaryOrange,lineWidth:4)
                        .frame(width: 120)
                        .overlay(){
                            Image(sport)
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width:100, height: 100)
                                .foregroundStyle(.gray200)
                                .accessibilityLabel("Desenho representando o esporte  \(sport) ")
                        }
                    Form{
                        TextField("Titulo",text:$title)
                            .autocorrectionDisabled(true)
                        TextField("Descrição",text:$description)
                            .autocorrectionDisabled(true)
                            .padding(.bottom)
                        
                        Section{
                            TextField("Localização", text: $location)
                        }
                        
                        Section{
                            Picker("Esporte", selection: $sport){
                            ForEach(SPORTS, id: \.self){
                                        Text("\($0) ").tag("\($0)")
                                    }
                                }
                            HStack{
                                Text("Num. de Pessoas")
                                TextField("", value: $peopleNumber, formatter: NumberFormatter())
                            }
                        }
                        Section{
                            DatePicker("Data de Início ", selection: $startDate)
                                .padding(.bottom)
                            DatePicker("Data de Término ", selection: $endDate)
                                .padding(.bottom)
                        }
                        
                        
                    }
                    
                    
                    Button("enviar"){
                        detalhes.toggle()
                        
                    }
                    .foregroundStyle(/*@START_MENU_TOKEN@*/.blue/*@END_MENU_TOKEN@*/)
                    if (detalhes){
                        Spacer()
                        Text("Titulo: \(title)")
                        Text("localizacao: \(location)")
                        Text("Capacidade de pessoas: \(peopleNumber).")
                        Text("Esporte escolhido: \(sport)")
                        
                    }
                }
            }
            .navigationTitle("Novo Evento")
            .navigationBarTitleDisplayMode(.inline)
            
        }
    }
}

#Preview {
    EditEventView()
}
