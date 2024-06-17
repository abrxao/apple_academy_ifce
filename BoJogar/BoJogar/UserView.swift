//
//  ContentView.swift
//  BoJogar
//
//  Created by found on 30/04/24.
//  http-server json javascript

import SwiftUI

// ContentView.swif
struct UserView: View {
    
    var body: some View {
        ZStack(alignment: .topLeading){
            Image("courtBg")
                .resizable()
                .frame(maxWidth: .infinity)
                .scaledToFit()
            
            ScrollView(showsIndicators: false) {
                VStack(alignment: .leading) {
                    Spacer()
                        .frame(height: 40)
                        .frame(maxWidth: .infinity)
                    Text("Olá,")
                        .font(.largeTitle)
                        .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                        .foregroundStyle(.white)
                        .shadow(radius: 4, y:4)
                        .shadow(color:.gray700, radius: 1)
                        .multilineTextAlignment(.leading)
                        
                    
                    Text("John Doe!")
                        .font(.largeTitle)
                        .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                        .foregroundStyle(.white)
                        .shadow(radius: 4, y:4)
                        .shadow(color:.gray700, radius: 1)
                        .multilineTextAlignment(.leading)
                    
                    Text("Que atividade você deseja praticar hoje?")
                        .shadow(radius: 4, y:4)
                        .fontWeight(.semibold)
                        .foregroundStyle(.white)

                    
                }
                .padding(.horizontal,20)
                
                Spacer()
                    .frame(height: 22)
                
                EventUserCardView()
                    .padding(.horizontal,20)
                    .padding(.vertical,32)
                    .background(.white)
                    .clipShape(UnevenRoundedRectangle(topLeadingRadius: 32, bottomLeadingRadius: 0, bottomTrailingRadius: 0, topTrailingRadius: 32, style: .continuous))
                    
                
            }
            .frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/)
        }
        .frame(maxWidth: .infinity)
        .background(.primaryBlue)
    }
}

#Preview {
    NavigationStack {
        UserView()
    }
}
