//
//  Place.swift
//  BoJogar
//
//  Created by found on 11/06/24.
//

import Foundation
import MapKit



struct Place: Identifiable{
    let id = UUID().uuidString
    private var mapItem: MKMapItem
    
    init(mapItem:MKMapItem){
        self.mapItem = mapItem
    }
    var name: String {
        self.mapItem.name ?? ""
    }
    
    func openInMaps() async throws
    {
           let url = URL(string: "\(API_BASE_URL)/locals")!
           var request = URLRequest(url: url)
           request.httpMethod = "POST"
           request.setValue("application/json", forHTTPHeaderField: "Content-Type")
           request.setValue("true", forHTTPHeaderField: "ngrok-skip-browser-warning")
           let encoder = JSONEncoder()
           
           do {
               let json = LocalCardModel(
                                    id:nil,
                                    name: self.name,
                                    latitude: self.longitude,
                                    longitude: self.latitude,
                                    address: self.address)
               
               let localData = try encoder.encode(json)
               request.httpBody = localData
               
               let (_, response) = try await URLSession.shared.data(for: request)
               
               if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 201 {
                   print("Event added successfully.")
                   let decoder = JSONDecoder()
                   do {
                       _ = try decoder.decode(LocalCardModel.self, from: localData)
                        // Save to local storage
                   } catch {
                       print("Error decoding response data: \(error)")
                   }
                   
               } else {
                   print("Failed to add event.")
               }
           } catch {
               print("Error adding event: \(error)")
               throw error
        
       }
        //self.mapItem.openInMaps()
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
