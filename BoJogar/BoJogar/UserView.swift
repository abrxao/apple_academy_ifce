//
//  ContentView.swift
//  BoJogar
//
//  Created by found on 30/04/24.
//  http-server json javascript

import SwiftUI

// ContentView.swif
struct UserView: View {
    @State private var locals:[LocalCardModel] = []
    var body: some View {
        ScrollView(showsIndicators: false) {
            Spacer()
                .frame(height: 4)
            
            Badge(text: "Locais Proximos")
            
            LocalCardView(locals:locals)
                .padding()
                .scrollClipDisabled(true)
            
            Spacer()
                .frame(height: 40)
            
            EventUserCardView()
        }
        .task{
            await getLocals()
        }
    }
    
    // Função async para pegar os dados dos locais do banco de dados
    func getLocals() async {
        guard let url = URL(string: "\(API_BASE_URL)/locals") else {
            print("Invalid URL")
            return
        }
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            let decodedData = try decoder.decode([LocalCardModel].self, from: data)
            self.locals = decodedData
        } catch {
            print(error)
        }
    }
}

#Preview {
    NavigationStack {
        UserView()
    }
}
