//
//  NearbyEventsView.swift
//  BoJogar
//
//  Created by found on 14/05/24.
//

import Foundation
import SwiftUI
import MapKit

struct Annotation: Identifiable{
    let id = UUID().uuidString
    var name : String
    var address : String
    var coordinate : CLLocationCoordinate2D
}

struct EventsPerLocal: View {
    @EnvironmentObject var locationManager: LocationManager
    
    @State private var localRepo: LocationRepo
    
    @State private var selectedEvent: EventModel?
    @State private var mapRegion = MKCoordinateRegion()
    @State private var annotations: [Annotation] = []
    
    var location: LocationModel
    
    let regionSize = 500.0
    
    init(location: LocationModel) {
        self._localRepo = State(initialValue: LocationRepo(location: location))
        self.location = location
    }
    
    var body: some View{
        
        ScrollView(showsIndicators: false) {
            VStack{
                Map(coordinateRegion: $mapRegion,
                    showsUserLocation: true,
                    annotationItems: annotations){annotation in
                    
                    MapMarker(coordinate: annotation.coordinate,tint:.primaryBlue)
                }
                .frame(maxWidth: .infinity)
                .frame(height: 328)
                VStack(alignment:.leading){
                    
                    SectionTitle(text: location.name)
                        .padding(.top, 24)
                    
                    Spacer()
                        .frame(height: 20)
                    
                    TextWithIcon(text: location.address, icon: "location.fill")
                    Spacer()
                        .frame(height: 12)
                    
                    
                    if(locationManager.location != nil){
                        let distance = " \(locationManager.location?.distance(from: CLLocation(latitude: location.latitude, longitude: location.longitude)) ?? 0.0)"
                        
                        TextWithIcon(text: distance.extractDistanceFormatted, icon: "map.fill")
                        
                        
                    }
                    
                    Spacer()
                        .frame(height: 32)
                    if (!localRepo.events.isEmpty){
                        SectionTitle(text: "Eventos Cadastrados")
                        Spacer()
                            .frame(height: 24)
                        
                        ForEach(localRepo.events, id: \.id) { event in // Iterate over items
                            Button {
                                selectedEvent = event
                            } label: {
                                EventCard(event: event)
                            }
                        }
                    }
                    
                }
                .padding(.horizontal,16)
                .frame(maxWidth: .infinity)
                .background(.white)
                .clipShape(UnevenRoundedRectangle(
                    topLeadingRadius: 16,
                    bottomLeadingRadius: 0,
                    bottomTrailingRadius: 0,
                    topTrailingRadius: 16,
                    style: .continuous))
                .offset(y:-24)
                
                Spacer()
                    .frame(height: 36)
            }
            .offset(y:-124)
        }
        .navigationBarTitleDisplayMode(.inline)
        .navigationDestination(item: $selectedEvent, destination: { event in
            EventSelected(event: event)
        })
        
        .task {
            let offsetForCenterMap = 0.0005
            
            let centerMap = CLLocationCoordinate2D(
                latitude: location.latitude + offsetForCenterMap,
                longitude: location.longitude)
            
            mapRegion = MKCoordinateRegion(center: centerMap, 
                                           latitudinalMeters: regionSize,
                                           longitudinalMeters: regionSize)
            
            annotations = [Annotation(name: location.name, 
                                      address: location.address,
                                      coordinate: location.coordinate)]
            await localRepo.getLocalEvents()
        }
        
        
        
    }
    
}
