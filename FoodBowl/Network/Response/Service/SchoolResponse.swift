//
//  SchoolResponse.swift
//  FoodBowl
//
//  Created by COBY_PRO on 2023/09/10.
//

import CoreLocation
import Foundation

struct SchoolResponse: Codable {
    let schools: [School]
}

struct School: Codable {
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
}
