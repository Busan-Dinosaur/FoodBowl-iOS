//
//  Store.swift
//  FoodBowl
//
//  Created by Coby on 1/17/24.
//

import Foundation

// MARK: - StoreItem
struct Store: Codable {
    let id: Int
    let categoryName: String
    let name: String
    let addressName: String
    let isBookmarked: Bool
    let distance: String
    let url: String
    let x, y: Double
    let reviewCount: String
}
