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
    //@State private var selectedLocal: Bool = false
    @State private var selectedLocal: LocalCardModel?
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            // Use ScrollView with horizontal orientation
//            NavigationStack{
                HStack(spacing: 10) { // Use LazyHStack for efficiency
                    ForEach(locals) { local in // Iterate over items
                        Button {
                            selectedLocal = local
                        } label: {
                            LocalCard(local: local)
                        }
                    }
                }
                .padding(.vertical, 5)
//            }
        }
        .navigationDestination(item: $selectedLocal, destination: { item in
            EventsPerLocal(localID: item.id)
        })
        .navigationTitle("Início")
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarHidden(true)
//        .navigationDestination(isPresented: $selectedLocal) {
//        } // cmd option { } sobe e desce linhas
        .task {
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

struct LocalCard: View {
    let local: LocalCardModel

    var body: some View {
        VStack(alignment: .leading) {
            ImageURL(url: URL(string: local.imageURL)!, skeletonHeight: 164)
                .aspectRatio(51/58, contentMode: .fit)
                // Clip the image to the frame
            
            Text(local.title)
                .foregroundStyle(.white)
                .padding(.horizontal, 8)
                .padding(.vertical, 6)
                .frame(maxWidth: .infinity, alignment: .leading)
                // Align text to the left
                
            
            Spacer()
                .frame(height: 12)
        }
        .containerRelativeFrame(.horizontal, count: 15, span: 7, spacing: 0,alignment: .topLeading)
        .background(.redSecondary) // Add background color to each item
        .cornerRadius(10) // Add corner radius to each item
        .shadow(radius: 2, y: 2.0) // Add shadow to each item
    }
}
