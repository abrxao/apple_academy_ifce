
import Foundation
import SwiftUI
import CoreLocation

struct HeaderView: View {
    var body: some View {
        Image("courtBg")
            .resizable()
            .frame(maxWidth: .infinity)
            .scaledToFit()
            .accessibilityHidden(true)
            .padding(.vertical,64)
            .background(.primaryBlue)
    }
}

// ListView.swift
struct LocationsView: View {
    @EnvironmentObject var locationManager : LocationManager
    @State private var locations:[LocationModel] = []
    @State private var selectedLocal: LocationModel?
    @State private var isLoadingLocations = false
    let columns = [
        GridItem(.flexible(minimum: 100, maximum: 240)),
        GridItem(.flexible(minimum: 100, maximum: 240))
    ]
    
    var body: some View {
        if (locationManager.location == nil){
            Text("Habilite a sua localização para ver esta página")
        }else{
            
            NavigationStack {
                ScrollView(.vertical, showsIndicators: false) {
                    VStack{
                        HeaderView()
                            .background(.primaryBlue)
                        
                        VStack(alignment:.leading) {
                            if(!isLoadingLocations){
                                if(!locations.isEmpty){
                                    SectionTitle(text: "Locais")
                                    
                                    LazyVGrid(columns: columns, spacing: 20) {
                                        
                                        ForEach(locations, id:\.id) { location in
                                            
                                            let distance = "\(locationManager.location?.distance(from: CLLocation(latitude: location.latitude, longitude: location.longitude)) ?? 0.0)"
                                            Button {
                                                selectedLocal = location
                                            } label: {
                                                LocalCard(local: location, distance: distance.extractDistance)
                                            }
                                            
                                        }
                                    }
                                }
                                else{
                                    SectionTitle(text: "Ainda não tem locais com eventos próximos a você")
                                }
                                
                            }else{
                                LocationsSkeleton()
                            }
                        }
                        .frame(maxWidth: .infinity)
                        .padding(.horizontal,20)
                        .padding(.vertical,32)
                        .background(.gray50)
                        .clipShape(UnevenRoundedRectangle(
                            topLeadingRadius: 32,
                            bottomLeadingRadius: 0,
                            bottomTrailingRadius: 0,
                            topTrailingRadius: 32,
                            style: .continuous))
                        .offset(y:-64)
                        .navigationDestination(item: $selectedLocal, destination: { location in
                            EventsPerLocal(location: location)
                        })
                        .navigationTitle("Locais")
                        .navigationBarTitleDisplayMode(.inline)
                        .navigationBarHidden(true)
                    }
                }
                .offset(y:-64)
                .background(.gray50)
            }
            .task{
                await getLocations()
            }
        }
    }
    
    func getLocations() async {
        isLoadingLocations = true
        guard let deviceLocation = locationManager.location else {
            print("Location is not available")
            return
        }
        
        let url = URL(string: "\(API_BASE_URL)/locals_with_events")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let encoder = JSONEncoder()
        
        do {
            let userBody = try encoder.encode([
                "latitude": deviceLocation.coordinate.latitude,
                "longitude": deviceLocation.coordinate.longitude
            ])
            request.httpBody = userBody
            
            let (data, response) = try await URLSession.shared.data(for: request)
            guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) else {
                
                print("Server error")
                return
            }
            
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            let decodedData = try decoder.decode([LocationInDB].self, from: data)
            
            let locations = decodedData.map { locationInDB in
                LocationModel(
                    id: locationInDB._id,
                    name: locationInDB.name,
                    latitude: locationInDB.location.coordinates[1],
                    longitude: locationInDB.location.coordinates[0],
                    address: locationInDB.address
                )
            }
            
            self.locations = locations
            
        } catch {
            print("Error: \(error.localizedDescription)")
        }
        isLoadingLocations = false
    }
}

