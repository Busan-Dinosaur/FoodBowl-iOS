//
//  StoreDTO.swift
//  FoodBowl
//
//  Created by COBY_PRO on 10/12/23.
//

import Foundation

// MARK: - StoreDTO
struct StoreDTO: Codable {
    let stores: [StoreItemDTO]
}

// MARK: - StoreItemDTO
struct StoreItemDTO: Codable {
    let id: Int
    let name, categoryName, addressName, url: String
    let x, y: Double
    let reviewCount: Int
    let isBookmarked: Bool
}

// MARK: - StoreBySearchDTO
struct StoreBySearchDTO: Codable {
    let searchResponses: [StoreItemBySearchDTO]
}

// MARK: - StoreItemBySearchDTO
struct StoreItemBySearchDTO: Codable {
    let storeId: Int
    let storeName: String
    let distance: Double
    let reviewCount: Int
}
