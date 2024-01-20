//
//  Store.swift
//  FoodBowl
//
//  Created by Coby on 1/17/24.
//

import Foundation

// MARK: - Store
struct Store: Codable {
    let id: Int
    let category: String
    let name: String
    let address: String
    let isBookmark: Bool
    let distance: String
    let url: String
    let x, y: Double
    let reviewCount: String
}
