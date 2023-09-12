//
//  SchoolResponse.swift
//  FoodBowl
//
//  Created by COBY_PRO on 2023/09/10.
//

import Foundation

struct SchoolResponse: Decodable {
    let schools: [School]
}

struct School: Decodable {
    let id: Int
    let name: String
    let x: Double
    let y: Double
}
