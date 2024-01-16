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
    
    func toStore() -> Store {
        return Store(
            id: self.id,
            categoryName: self.categoryName,
            name: self.name,
            addressName: self.addressName,
            isBookmarked: self.isBookmarked,
            distance: nil,
            url: self.url,
            x: self.x,
            y: self.y,
            reviewCount: self.reviewCount
        )
    }
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
    
    func toStore() -> Store {
        return Store(
            id: self.storeId,
            categoryName: nil,
            name: self.storeName,
            addressName: nil,
            isBookmarked: nil,
            distance: self.distance,
            url: nil,
            x: nil,
            y: nil,
            reviewCount: self.reviewCount
        )
    }
}
