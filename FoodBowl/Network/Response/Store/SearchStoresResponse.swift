//
//  SearchStoresResponse.swift
//  FoodBowl
//
//  Created by COBY_PRO on 10/12/23.
//

import Foundation

// MARK: - SearchStoresResponse
struct SearchStoresResponse: Codable {
    let searchResponses: [StoreBySearch]
}

// MARK: - StoreBySearch
struct StoreBySearch: Codable {
    let storeId: Int
    let storeName: String
    let distance: Double
    let reviewCount: Int
}
