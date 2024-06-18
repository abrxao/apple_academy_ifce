//
//  NearbyEventsView.swift
//  BoJogar
//
//  Created by found on 14/05/24.
//

import Foundation
import SwiftUI
import MapKit

struct EventsPerLocal: View {
    @EnvironmentObject var locationManager: LocationManager
    struct Annotation: Identifiable{
        let id = UUID().uuidString
        var name : String
        var address : String
        var coordinate : CLLocationCoordinate2D
    }
    @State private var localRepo: LocationRepo
    
    @State private var selectedEvent: EventModel?
    @State private var mapRegion = MKCoordinateRegion()
    @State private var annotations: [Annotation] = []
    
    var location: LocationModel
    
    let regionSize = 250.0
    
    init(location: LocationModel) {
        self._localRepo = State(initialValue: LocationRepo(location: location))
        self.location = location
    }
    
    var body: some View{
        
        ScrollView(showsIndicators: false) {
            
            Map(coordinateRegion: $mapRegion, annotationItems: annotations){annotation in
                MapMarker(coordinate: annotation.coordinate)
            }
            .frame(maxWidth: .infinity)
            .frame(height: 180)
            VStack(alignment:.leading){
                
                Text(location.name)
                    .font(/*@START_MENU_TOKEN@*/.title/*@END_MENU_TOKEN@*/)
                    .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                    .foregroundStyle(.red900)
                    .frame(maxWidth: .infinity, alignment: .leading)
                Spacer()
                    .frame(maxWidth: .infinity)
                    .frame(height: 1)
                    .background(.gray200)
                Spacer()
                    .frame(height: 20)
                
                
                HStack(alignment:.center){
                    Image(systemName: "location.fill")
                        .foregroundStyle(.redSecondary)
                    Text(location.address)
                    
                }
                Spacer()
                    .frame(height: 16)
                HStack(alignment:.center){
                    Image(systemName: "map.fill")
                        .foregroundStyle(.redSecondary)
                    if(locationManager.location != nil){
                        let distance = " \(locationManager.location?.distance(from: CLLocation(latitude: location.latitude, longitude: location.longitude)) ?? 0.0)"
                        
                        Text(distance.extractDistanceFormatted)}
                    
                }
                if (!localRepo.events.isEmpty){
                    
                    SectionTitle(text: "Eventos Confirmados")
                    
                    Spacer()
                        .frame(height: 12)
                    
                    ForEach(localRepo.events, id: \.id) { event in // Iterate over items
                        Button {
                            selectedEvent = event
                        } label: {
                            EventCard(event: event)
                        }
                    }
                }
                
            }.padding(.horizontal,16)
            
            Spacer()
                .frame(height: 36)
            
        }
        .navigationBarTitleDisplayMode(.inline)
        .navigationDestination(item: $selectedEvent, destination: { event in
            EventSelected(event: event)
        })
        .task {
            mapRegion = MKCoordinateRegion(center: location.coordinate, latitudinalMeters: regionSize, longitudinalMeters: regionSize)
            annotations = [Annotation(name: location.name, address: location.address, coordinate: location.coordinate)]
            
            await localRepo.getLocalEvents()
        }
        
        
    }
    
}
