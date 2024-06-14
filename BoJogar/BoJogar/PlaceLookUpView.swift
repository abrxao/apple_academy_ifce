//
//  PlaceLookUpView.swift
//  BoJogar
//
//  Created by found on 11/06/24.
//

import Foundation
import SwiftUI

struct PlaceLookUpView: View {
    @EnvironmentObject var locationManager: LocationManager
    @StateObject private var placeVM = PlaceViewModel() // we can init as a @StateObject here if this is the first or only place we'll use this View Model
    @State private var searchText = ""
    
    
    var body: some View {
        NavigationStack{
            List(placeVM.places, id:\.id){ place in
                VStack(alignment:.leading){
                    Text(place.name)
                        .font(.title2)
                    Text(place.address)
                        .font(.callout)
                    
                }
            }
            .listStyle(.plain)
            .searchable(text: $searchText)
            .onChange(of: searchText, perform: {text in
                if !text.isEmpty {
                    placeVM.search(text: text, region: locationManager.region)
                }else{
                    placeVM.places = []
                }
            })
            
        }
        
    }
}
