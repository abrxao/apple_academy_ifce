//
//  ContentView.swift
//  BoJogar
//
//  Created by found on 30/04/24.
//  http-server json javascript

import SwiftUI

// ContentView.swif
struct UserView: View {
    @EnvironmentObject var userRepo: UserRepo
    
    var body: some View {
        
        ScrollView(showsIndicators: false) {
            ZStack(alignment: .topLeading){
                
                HeaderView()
                    .opacity(0.4)
                    .background(.primaryBlue)
                
                VStack{ 
                    if (userRepo.userData != nil){
                        VStack(alignment: .leading) {
                            Spacer()
                                .frame(height: 40)
                                .frame(maxWidth: .infinity)
                            Text("Olá,")
                                .font(.largeTitle)
                                .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                                .foregroundStyle(.gray50)
                                .shadow(radius: 4, y:4)
                                .shadow(color:.gray700, radius: 1)
                                .multilineTextAlignment(.leading)
                            
                            Text(userRepo.userData?.fullName ?? " ")
                                .font(.largeTitle)
                                .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                                .foregroundStyle(.gray50)
                                .shadow(radius: 4, y:4)
                                .shadow(color:.gray700, radius: 1)
                                .multilineTextAlignment(.leading)
                            
                            Text("Veja aqui seus eventos!")
                                .shadow(radius: 4, y:4)
                                .shadow(color:.gray700,radius: 1)
                                .fontWeight(.semibold)
                                .foregroundStyle(.gray50)
                        }
                        .padding(.horizontal,20)
                    }
                    else{
                        UserHeaderSkeleton()
                    }
                    Spacer()
                        .frame(height: 22)
                    
                    UserEventsView()
                        .padding(.horizontal,20)
                        .padding(.vertical,32)
                        .background(.gray50)
                        .clipShape(UnevenRoundedRectangle(
                            topLeadingRadius: 32,
                            bottomLeadingRadius: 0,
                            bottomTrailingRadius: 0,
                            topTrailingRadius: 32,
                            style: .continuous))
                }
                .padding(.top,64)
            }
            .frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/)
            .background(.gray50)
            .offset(y:-64)
        }
        .frame(maxWidth: .infinity)
        .background(.gray50)
        .task{
            await userRepo.getUserData()
        }
        
    }
}

#Preview {
    NavigationStack {
        UserView()
    }
}
