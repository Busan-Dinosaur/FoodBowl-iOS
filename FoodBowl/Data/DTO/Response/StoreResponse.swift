//
//  StoreResponse.swift
//  FoodBowl
//
//  Created by COBY_PRO on 10/12/23.
//

import Foundation

// MARK: - StoreResponse
struct StoreResponse: Codable {
    let stores: [Store]
}

// MARK: - Store
struct Store: Codable {
    let id: Int
    let name, categoryName, addressName, url: String
    let x, y: Double
    let reviewCount: Int
    let isBookmarked: Bool
}
