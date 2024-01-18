//
//  Place.swift
//  FoodBowl
//
//  Created by Coby on 1/19/24.
//

import Foundation

// MARK: - Place
struct Place: Codable {
    let id: String
    let name: String
    let address: String
    let phone: String
    let url: String
    let distance: String
    let x, y: String
    let category: String
}
