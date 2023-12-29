//
//  ReviewDTO.swift
//  FoodBowl
//
//  Created by COBY_PRO on 10/12/23.
//

import Foundation

// MARK: - ReviewDTO
struct ReviewDTO: Codable {
    let reviews: [ReviewItemDTO]
    let page: PageDTO
}

// MARK: - PageDTO
struct PageDTO: Codable {
    let firstId, lastId: Int?
    let size: Int
}

// MARK: - ReviewItemDTO
struct ReviewItemDTO: Codable, Hashable {
    let writer: WriterItemDTO
    let review: CommentDTO
    var store: StoreByReviewDTO
    
    static func == (lhs: ReviewItemDTO, rhs: ReviewItemDTO) -> Bool {
        lhs.review.id == rhs.review.id
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(review.id)
    }
}

// MARK: - CommentDTO
struct CommentDTO: Codable {
    let id: Int
    let content: String
    let imagePaths: [String]
    let createdAt: String
    let updatedAt: String
}

// MARK: - StoreByReviewDTO
struct StoreByReviewDTO: Codable {
    let id: Int
    let categoryName, name, addressName: String
    let distance: Double
    var isBookmarked: Bool
}

// MARK: - WriterItemDTO
struct WriterItemDTO: Codable {
    let id: Int
    let nickname: String
    let profileImageUrl: String?
    let followerCount: Int
}

// MARK: - ReviewByStoreDTO
struct ReviewByStoreDTO: Codable {
    let storeReviewContentResponses: [ReviewItemByStoreDTO]
    let page: PageDTO
}

// MARK: - ReviewItemByStoreDTO
struct ReviewItemByStoreDTO: Codable, Hashable {
    let writer: WriterItemDTO
    let review: CommentDTO
    
    static func == (lhs: ReviewItemByStoreDTO, rhs: ReviewItemByStoreDTO) -> Bool {
        lhs.review.id == rhs.review.id
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(review.id)
    }
}
