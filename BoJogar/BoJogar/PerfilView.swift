//
//  PerfilView.swift
//  BoJogar
//
//  Created by found on 10/05/24.
//

import Foundation
import SwiftUI
//View de evento

struct PerfilView: View{
    @State private var isPresented = true
    
    var body: some View{
        
        ScrollView {
            VStack  {
                //perfil e informacoes
                
                
                HStack{
                    //foto Perfil, nome e email
                    
                    Circle()
                        .fill(Color.redSecondary)
                        .frame(width: 140,height: 140)
                    
                        .overlay(
                            Image("Persona1")
                                .resizable()
                                .scaledToFill()
                                .frame(width: 130,height:130)
                                .clipShape(Circle())
                                .accessibilityLabel("Foto de Perfil")
                        )
                    
                    Spacer()
                        .frame(width: 30)
                    VStack(alignment: .leading) {
                        Text("Maria Joaquina")
                            .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                            .font(.title2)
                        Text("maria.joaq@gmail.com")
                            .accentColor(.black)
                            .fontWeight(.light)
                            .underline()
                        
                    }
                    Spacer()
                        .frame(width: 10)
                    
                }
                Spacer()
                    .frame(height: 30)
                Rectangle()
                    .fill(Color.gray)
                    .frame(height: 1)
                    .padding(.horizontal)
                
                
                VStack(alignment: .leading) {
                    Text("Corrida, Crossfit, Yoga")
                        .font(.callout)
                        .lineLimit(1)
                    Text("Parquelândia, Fortaleza (CE)")
                        .font(.callout)
                        .lineLimit(2)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding()
                
                Spacer()
                    .frame(width: 20,height: 20)
                Text("Busco conhecer novas pessoas com interesse em Corrida, Crossfit ou Yoga para praticarmos algo juntos!!!")
                    
                    .lineLimit(3)
                    .padding(.horizontal)
                Spacer()
                    .frame(height: 30)
                
                Rectangle()
                    .fill(Color.gray)
                    .frame(height: 1)
                    .padding(.horizontal)
                
                
                Text("Histórico de Eventos")
                    .font(.title3)
                    .bold()
                    .foregroundStyle(Color(.red900))
                    
                Rectangle()
                    .fill(Color.gray)
                    .frame(height: 1)
                    .padding(.horizontal)
                Spacer()
                    .frame(height: 30)
                SearchEventsView()
            }
        }
        .sheet(isPresented: $isPresented) {
            EditPerfilView()
        }
    }
}
#Preview {
    PerfilView()
}
