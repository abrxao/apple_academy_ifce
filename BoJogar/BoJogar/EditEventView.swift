//
//  EditEventView.swift
//  BoJogar
//
//  Created by found on 17/06/24.
//

import SwiftUI

struct EditEventView: View {
    
    @Environment(\.dismiss) var dismiss
    @State private var titulo = ""
    @State private var localizacao = ""
    @State private var esporte = "Badminton"
    @State private var numPessoas = 0
    @State private var detalhes=false
    @State private var dataInicio: Date = Date()
    @State private var dataTermino: Date = Date()

    
    var body: some View {
        
        NavigationStack{
            VStack{
                Rectangle()
                    .frame(height: 1)
                    .foregroundStyle(.gray)
                Spacer()
                VStack{
                    Circle()
                        .stroke()
                        .frame(width: 160)
                        .overlay(){
                            Image(esporte)
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width:120, height: 120)
                                .foregroundStyle(.gray200)
                                .accessibilityLabel("Desenho representando o esporte  \(esporte) ")
                        }
                    Form{
                        TextField("Titulo:",text:$titulo)
                            .autocorrectionDisabled(true)
                            .padding(.bottom)
                        TextField("Localizacão:",text:$localizacao)
                            .autocorrectionDisabled(true)
                            .padding(.bottom)
                        
                        Section{
                            Picker("esporte", selection: $esporte){
                            ForEach(SPORTS, id: \.self){
                                        Text("\($0) ").tag("\($0)")
                                    }
                                }
                            HStack{
                                Text("Num. de Pessoas")
                                TextField("", value: $numPessoas, formatter: NumberFormatter())
                            }
                        }
                        Section{
                            DatePicker("Data de Início ", selection: $dataInicio)
                            
                            DatePicker("Data de Término ", selection: $dataTermino)
                        }
                        
                        
                    }
                    
                    /*
                    Button("enviar"){
                        detalhes.toggle()
                        
                    }
                    .foregroundStyle(/*@START_MENU_TOKEN@*/.blue/*@END_MENU_TOKEN@*/)
                    if (detalhes){
                        Spacer()
                        Text("Titulo: \(titulo)")
                        Text("localizacao: \(localizacao)")
                        Text("Capacidade de pessoas: \(numPessoas).")
                        Text("Esporte escolhido: \(esporte)")
                        
                    } */
                }
            }
            .navigationTitle("Evento")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        // Save...
                        dismiss()
                      
                    }
                }
            }
        }
    }
}

#Preview {
    EditEventView()
}
