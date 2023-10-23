//
//  ReviewResponse.swift
//  FoodBowl
//
//  Created by COBY_PRO on 10/12/23.
//

import Foundation

// MARK: - ReviewResponse
struct ReviewResponse: Codable {
    let reviews: [Review]
    let page: Page
}

// MARK: - Page
struct Page: Codable {
    let firstId, lastId: Int?
    let size: Int
}

// MARK: - Review
struct Review: Codable, Hashable {
    let writer: Writer
    let review: ReviewContent
    var store: StoreByReview
}

// MARK: - ReviewContent
struct ReviewContent: Codable, Hashable {
    let id: Int
    let content: String
    let imagePaths: [String]
    let createdAt: String
    let updatedAt: String
}

// MARK: - StoreByReview
struct StoreByReview: Codable, Hashable {
    let id: Int
    let categoryName, name, addressName: String
    let distance: Double
    var isBookmarked: Bool
}

// MARK: - Writer
struct Writer: Codable, Hashable {
    let id: Int
    let nickname: String
    let profileImageUrl: String?
    let followerCount: Int
}
