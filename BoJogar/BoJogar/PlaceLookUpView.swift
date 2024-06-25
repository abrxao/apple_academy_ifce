//
//  PlaceLookUpView.swift
//  BoJogar
//
//  Created by found on 11/06/24.
//

import Foundation
import SwiftUI

struct PlaceLookUpView: View {
    @Environment(\.dismiss) var dismiss
    @Binding var selectedPlace: LocationModel?
    @EnvironmentObject var locationManager: LocationManager
    @StateObject private var placeVM = PlaceViewModel() // we can init as a @StateObject here if this is the first or only place we'll use this View Model
    @State private var searchText: String = ""
    
    var body: some View {
        NavigationStack{
            List(placeVM.places, id:\.id){ place in
                Button{
                    selectedPlace = LocationModel(id: nil,
                                                  name: place.name,
                                                  latitude: place.latitude,
                                                  longitude: place.longitude,
                                                  address: place.address)
                    dismiss.callAsFunction()
                }label:{
                    VStack(alignment:.leading){
                        Text(place.name)
                            .font(.title2)
                        Text(place.address)
                            .font(.callout)
                    }
                }
            }
            .listStyle(.plain)
            .searchable(text: $searchText)
            .onChange(of: searchText){
                if !searchText.isEmpty {
                    placeVM.search(text: searchText, region: locationManager.region)
                }else{
                    placeVM.places = []
                }
            }
            
        }
        
    }
}
