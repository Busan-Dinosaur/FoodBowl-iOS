//
//  ReviewByStoreResponse.swift
//  FoodBowl
//
//  Created by COBY_PRO on 10/16/23.
//

import Foundation

// MARK: - ReviewByStoreResponse
struct ReviewByStoreResponse: Codable {
    let storeReviewContentResponses: [ReviewByStore]
    let page: Page
}

// MARK: - ReviewByStore
struct ReviewByStore: Codable, Hashable {
    let writer: Writer
    let review: ReviewContent
}
