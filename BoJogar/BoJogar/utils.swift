//
//  utils.swift
//  BoJogar
//
//  Created by found on 28/05/24.
//

import Foundation

extension String {
    
    var extractDateFormatted: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        formatter.timeZone = TimeZone(identifier: "UTC")
        
        guard let date = formatter.date(from: self) else {
            return "Invalid date"
        }
        
        formatter.timeZone = TimeZone(identifier: "America/Sao_Paulo")
        formatter.dateFormat = "yyyy-MM-dd 'às' HH:mm"
        
        return formatter.string(from: date)
    }
    
}
