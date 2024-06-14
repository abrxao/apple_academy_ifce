//
//  utils.swift
//  BoJogar
//
//  Created by found on 28/05/24.
//

import Foundation
import CoreLocation

extension String {
    
    var extractDateFormatted: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        formatter.timeZone = TimeZone(identifier: "UTC")
        
        guard let date = formatter.date(from: self) else {
            return "Invalid date"
        }
        
        let calendar = Calendar.current
        
        formatter.timeZone = TimeZone(identifier: "America/Sao_Paulo")
        formatter.dateFormat = "HH:mm"
        let timeString = formatter.string(from: date)
        
        if calendar.isDateInToday(date) {
            return "hoje às \(timeString)"
        } else if calendar.isDateInTomorrow(date) {
            return "amanhã às \(timeString)"
        } else {
            formatter.dateFormat = "dd/MM/yyyy 'às' HH:mm"
            return formatter.string(from: date)
        }
    }
}

