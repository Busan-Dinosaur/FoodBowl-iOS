//
//  SearchStoresResponse.swift
//  FoodBowl
//
//  Created by COBY_PRO on 10/12/23.
//

import Foundation

// MARK: - SearchStoresResponse
struct SearchStoresResponse: Codable {
    let searchResponses: [SearchResponse]
}

// MARK: - SearchResponse
struct SearchResponse: Codable {
    let storeId: Int
    let storeName: String
    let distance: Double
    let reviewCount: Int
}
