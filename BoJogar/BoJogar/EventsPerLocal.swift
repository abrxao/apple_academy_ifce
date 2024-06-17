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
    struct Annotation: Identifiable{
        let id = UUID().uuidString
        var name : String
        var address : String
        var coordinate : CLLocationCoordinate2D
    }
    @State private var localRepo: LocalRepo
    @State private var selectedEvent: EventCardModel?
    @State private var mapRegion = MKCoordinateRegion()
    @EnvironmentObject var locationManager: LocationManager
    @State private var annotations: [Annotation] = []
   
    var local: LocalCardModel
    
    let regionSize = 250.0
    
    init(local_: LocalCardModel) {
        self._localRepo = State(initialValue: LocalRepo(local_: local_))
        self.local = local_
    }
    
    var body: some View{
        
        ScrollView(showsIndicators: false) {
            
                Map(coordinateRegion: $mapRegion,
                    annotationItems: annotations){annotation in
                    MapMarker(coordinate: annotation.coordinate)
                }
                .frame(maxWidth: .infinity)
                .frame(height: 180)
                VStack(alignment:.leading){
                    
                    Text(local.name)
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
                        Text(local.address)
                            
                    }
                    Spacer()
                        .frame(height: 16)
                    HStack(alignment:.center){
                        Image(systemName: "map.fill")
                            .foregroundStyle(.redSecondary)
                        if(locationManager.location != nil){
                            let distance = " \(locationManager.location?.distance(from: CLLocation(latitude: local.latitude, longitude: local.longitude)) ?? 0.0)"
                                                                              
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
                                EventUserCard(event: event)
                            }
                        }
                    }
                    
                }.padding(.horizontal,16)
                
                Spacer()
                    .frame(height: 36)
               
            
                
                /*VStack{
                    SkeletonView(width: .infinity, height: .infinity)
                        .frame(height: 64)
                        .cornerRadius(4)
                        .padding(.top,16)
                    
                    SkeletonView(width: .infinity, height: .infinity)
                        .frame(height: 24)
                        .cornerRadius(4)
                    SkeletonView(width: .infinity, height: .infinity)
                        .frame(height: 24)
                        .cornerRadius(4)
                    SkeletonView(width: .infinity, height: .infinity)
                        .frame(height: 24)
                        .cornerRadius(4)
                    SkeletonView(width: .infinity, height: .infinity)
                        .frame(height: 24)
                        .cornerRadius(4)
                    SkeletonView(width: .infinity, height: .infinity)
                        .frame(height: 24)
                        .cornerRadius(4)
                }
                .padding(.horizontal, 8)*/
                
            
            
        }
        .navigationBarTitleDisplayMode(.inline)
        .navigationDestination(item: $selectedEvent, destination: { event in
            EventSelected(event: event)
        })
        .task {
            mapRegion = MKCoordinateRegion(center: local.coordinate, latitudinalMeters: regionSize, longitudinalMeters: regionSize)
            annotations = [Annotation(name: local.name, address: local.address, coordinate: local.coordinate)]
            
            await localRepo.getLocalEvents()
        }
        
        
    }
        
}
