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
    let locals: [LocalCardModel] 
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
        .navigationDestination(item: $selectedLocal, destination: { local in
            EventsPerLocal(local_: local)
        })
        .navigationTitle("Início")
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarHidden(true)
//        .navigationDestination(isPresented: $selectedLocal) {
//        } // cmd option { } sobe e desce linhas
        
    }
    
}

struct LocalCard: View {
    let local: LocalCardModel

    var body: some View {
        VStack(alignment: .leading) {
            
            Text(local.name)
                .multilineTextAlignment(.leading)
                .lineLimit(2, reservesSpace: true)
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
