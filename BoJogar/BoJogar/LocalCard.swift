//
//  local-card.swift
//  BoJogar
//
//  Created by found on 30/04/24.
//

import Foundation
import SwiftUI

// ListView.swift
struct LocalCardView: View {
    @State private var locals: [LocalCardModel] = []
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) { // Use ScrollView with horizontal orientation
            HStack(spacing: 10) { // Use LazyHStack for efficiency
                ForEach(locals, id: \.id) { local in // Iterate over items
                    LocalCard(local: local) // Render each item using ListItemView
                }                    
            }
            .padding(.vertical, 5)// Add horizontal padding
        }
        .task{
            await getLocals()
        }
    }
    // Função async para pegar os dados dos locais do banco de dados
    func getLocals() async {
        guard let url = URL(string: "http://localhost:3001/locals") else {
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

struct LocalCard: View {
    let local: LocalCardModel

    var body: some View {
        VStack(alignment: .leading) {
            ImageURL(url:URL(string:local.imageURL)!)
                 // Clip the image to the frame

            Text(local.title)
                .padding(.horizontal,8)
                .padding(.vertical,6)
        
        }
        .frame(width: 174)// Set fixed width for each item
         // Add padding to each item
        .background(Color.white) // Add background color to each item
        .cornerRadius(10) // Add corner radius to each item
        .shadow(radius: 2, y: 2.0) // Add shadow to each item
    }
}
