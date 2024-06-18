
import Foundation
import SwiftUI


// ListView.swift
struct LocalCardView: View {
    let locations: [LocationModel]
    @State private var selectedLocal: LocationModel?
    
    var body: some View {
        NavigationStack{
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 10) {
                    ForEach(locations) { local in
                        Button {
                            selectedLocal = local
                        } label: {
                            LocalCard(local: local)
                        }
                    }
                }
                .padding(.vertical, 5)
            }
            .navigationDestination(item: $selectedLocal, destination: { location in
                EventsPerLocal(location: location)
            })
            .navigationTitle("Início")
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarHidden(true)
            
        }
    }
    
}
