//
//  EditPerfilView.swift
//  BoJogar
//
//  Created by found on 17/05/24.
//

import SwiftUI

struct EditPerfilView: View {
    
    @Environment(\.dismiss) var dismiss
    @State private var userName = ""
    @State private var email = ""
    @State private var password = ""
    
    @State private var location = ""
    @State private var gender = ""
    @State private var sports = ""
    @State private var description = ""
   
    
    var body: some View {
        
        NavigationStack {
            VStack {
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
                                .foregroundStyle(.gray50)
                                .offset(x:-7,y:20)
                        }
                    
                    Form{
                        TextField("Email:",text: $email)
                            .autocorrectionDisabled(true)
                            .padding(.bottom)
                        SecureField("Senha",text: $password)
                            .autocorrectionDisabled(true)
                            .padding(.bottom)
                        TextField("Nome", text: $userName)
                            .autocorrectionDisabled(true)
                            .padding(.bottom)
                        TextField("Localizacao", text: $location)
                            .autocorrectionDisabled(true)
                            .padding(.bottom)
                        Picker("Gênero", selection: $gender){
                            Text("Feminino").tag("Feminino")
                            Text("Masculino").tag("Masculino")
                            Text("Outro").tag("Outro")
                        }
                        
                        Picker("Esportes",selection: $sports){
                            Text("Corrida").tag("Corrida")
                            Text("Basquete").tag("Basquete")
                            Text("Vôlei").tag("Vôlei")
                        }
                        
                        TextField("Descricao", text:$description)
                            .autocorrectionDisabled(true)
                        
                    }
                }
            }
            .navigationTitle("Editar Perfil")
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
    PerfilView()
}

