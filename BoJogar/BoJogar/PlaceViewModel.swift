//
//  PlaceViewModel.swift
//  BoJogar
//
//  Created by found on 11/06/24.
//

import Foundation
import MapKit

@MainActor
class PlaceViewModel: ObservableObject{
    @Published var places:[PlaceModel] = []
    
    func search(text:String,region:MKCoordinateRegion){
        let searchRequest = MKLocalSearch.Request()
        searchRequest.naturalLanguageQuery = text
        searchRequest.region = region
        let search = MKLocalSearch(request: searchRequest)
        
        search.start{response, error in
            guard let response = response else {
                print("ERROR: \(error?.localizedDescription ?? "Unknown Error")")
                return
            }
            self.places = response.mapItems.map(PlaceModel.init)
            
        }
    }
}
