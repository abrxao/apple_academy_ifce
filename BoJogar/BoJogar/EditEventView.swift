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
    @State private var esporte = ""
    @State private var numPessoas = 10
    @State private var detalhes=false
    
    var body: some View {
        
        //Text("oi")
        NavigationStack{
            VStack{
                Rectangle()
                    .frame(height: 1)
                    .foregroundStyle(.gray)
                Spacer()
                VStack{
                    Circle()
                        .fill(Color.redSecondary)
                        .frame(width: 140)
                        .overlay(){
                            Image(systemName: "photo")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width:80, height: 80)
                                .foregroundStyle(.gray200)
                        }
                        .overlay(alignment: .topTrailing) {
                            Circle()
                                .frame(width: 40, height: 40)
                                .offset(y: 15)
                                .foregroundStyle(.red900)
                        }
                        .overlay(alignment:.topTrailing){
                            Image(systemName: "camera.fill")
                                .resizable()
                                .aspectRatio(contentMode:.fit)
                                .frame(width: 25,height: 25)
                                .foregroundStyle(.white)
                                .offset(x:-7,y:20)
                        }
                    Form{
                        TextField("Titulo:",text:$titulo)
                            .autocorrectionDisabled(true)
                            .padding(.bottom)
                        TextField("Localizacão:",text:$localizacao)
                            .autocorrectionDisabled(true)
                            .padding(.bottom)
                        TextField("Capacidade de Pessoas", value: $numPessoas, format: .number)
                            
                        Section{
                            Picker("Esportes",selection: $esporte){
                                
                                Text("Corrida").tag("Corrida")
                                Text("Basquete").tag("Basquete")
                                Text("Vôlei").tag("Vôlei")
                            }
                            
                            //Stepper("\(numPessoas) pessoas", value:$numPessoas)
                            //.pickerStyle(.navigationLink)
                        }
                        
                    }
                    Button("enviar"){
                        detalhes.toggle()
                    }
                    .foregroundColor(/*@START_MENU_TOKEN@*/.blue/*@END_MENU_TOKEN@*/)
                    if detalhes==true{
                        Spacer()
                        Text("Titulo: \(titulo)")
                        Text("localizacao: \(localizacao)")
                        Text("Capacidade de pessoas: \(numPessoas).")
                        Text("Esporte escolhido: \(esporte)")
                    }
                    
                   
                    
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
