
import Foundation
import SwiftUI


struct HeaderView: View {
    var body: some View {
        Image("courtBg")
            .resizable()
            .frame(maxWidth: .infinity)
            .scaledToFit()
            .accessibilityHidden(true)
            .opacity(0.4)
            .padding(.vertical,64)
            .background(.primaryBlue)
            .offset(y:-64)
            .padding(.bottom)
    }
}

// ListView.swift
struct LocationsView: View {
    @State private var locations:[LocationModel] = []
    @State private var selectedLocal: LocationModel?
    
    var body: some View {
        
        NavigationStack {
            ScrollView(.vertical, showsIndicators: false) {
                ZStack(alignment: .topLeading){
                    
                    HeaderView()
                    VStack {
                        SectionTitle(text: "Locais")
                        Spacer()
                            .frame(maxWidth: 32)
                        HStack(spacing: 10) {
                            
                            ForEach(locations, id:\.id) { local in
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
                    .task{
                        await getLocations()
                    }
                    
                }
            }
        }
    }
        
        func getLocations() async{
            let url = URL(string: "\(API_BASE_URL)/locals_with_events")!
            var request = URLRequest(url: url)
            request.httpMethod = "GET"
            request.setValue("true", forHTTPHeaderField: "ngrok-skip-browser-warning")
            do {
                let (data, _) = try await URLSession.shared.data(for: request)
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                let decodedData = try decoder.decode([LocationModel].self, from: data)
                self.locations = decodedData
            } catch {
                print(error)
            }
            
        }
    }

