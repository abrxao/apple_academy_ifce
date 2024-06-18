//
//  Place.swift
//  BoJogar
//
//  Created by found on 11/06/24.
//

import Foundation
import MapKit

struct PlaceModel: Identifiable{
    let id = UUID().uuidString
    private var mapItem: MKMapItem
    
    init(mapItem:MKMapItem){
        self.mapItem = mapItem
    }
    var name: String {
        self.mapItem.name ?? ""
    }
    
    func openInMaps(){
        mapItem.openInMaps()
    }
    
    var address: String {
        let placemark = self.mapItem.placemark
        var cityAndState = ""
        var address = ""
        cityAndState = placemark.locality ?? ""//city
        if let state = placemark.administrativeArea{
            //Show either state or city, state
            cityAndState = cityAndState.isEmpty ? state : "\(cityAndState), \(state)"
        }
        address = placemark.subThoroughfare ?? "" // address number
        if let street = placemark.thoroughfare{
            //Just show the street unless there is a street number then add space + street
            address = address.isEmpty ? street : "\(street) \(address)"
        }
        if address.trimmingCharacters(in: .whitespaces).isEmpty && !cityAndState.isEmpty{
            //No address? Then just cityAndState with no space
            address = cityAndState
        }else{
            //No cityAndState? Then just address, otherwise address, cityAndState
            address = cityAndState.isEmpty ? address : "\(address) \(cityAndState)"
        }
        
        return address
    }
    
    var latitude: CLLocationDegrees {
        self.mapItem.placemark.coordinate.latitude
    }
    var longitude: CLLocationDegrees {
        self.mapItem.placemark.coordinate.longitude
    }
}
