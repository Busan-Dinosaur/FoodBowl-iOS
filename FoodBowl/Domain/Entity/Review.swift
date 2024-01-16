//
//  Review.swift
//  FoodBowl
//
//  Created by Coby on 1/17/24.
//

import Foundation

// MARK: - Review
struct Review: Codable {
    let reviews: [ReviewItem]
    let page: Page
}

// MARK: - Page
struct Page: Codable {
    let firstId, lastId: Int?
    let size: Int
}

// MARK: - ReviewItem
struct ReviewItem: Codable, Hashable {
    let writer: Writer
    let comment: Comment
    let store: StoreByReview?
    
    static func == (lhs: ReviewItem, rhs: ReviewItem) -> Bool {
        lhs.comment.id == rhs.comment.id
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(comment.id)
    }
}

// MARK: - Writer
struct Writer: Codable {
    let id: Int
    let nickname: String
    let profileImageUrl: String?
    let followerCount: Int
}

// MARK: - Comment
struct Comment: Codable {
    let id: Int
    let content: String
    let imagePaths: [String]
    let createdAt: String
    let updatedAt: String
}

// MARK: - StoreByReview
struct StoreByReview: Codable {
    let id: Int
    let categoryName, name, addressName: String
    let distance: Double
    var isBookmarked: Bool
}
