//
//  SchoolDTO.swift
//  FoodBowl
//
//  Created by COBY_PRO on 2023/09/10.
//

import CoreLocation
import Foundation

struct SchoolDTO: Codable {
    let schools: [SchoolItemDTO]
}

struct SchoolItemDTO: Codable {
    let id: Int
    let name: String
    let x: Double
    let y: Double
    let address: String

    var distance: String {
        guard let currentLoc = LocationManager.shared.manager.location else { return "" }
        let distance = currentLoc.distance(from: CLLocation(latitude: y, longitude: x))
        return String(distance).prettyDistance
    }
    
    func toStore() -> Store {
        Store(
            id: self.id,
            category: "",
            name: self.name,
            address: self.address,
            isBookmark: false,
            distance: self.distance,
            url: "",
            x: 0.0,
            y: 0.0,
            reviewCount: ""
        )
    }
}
