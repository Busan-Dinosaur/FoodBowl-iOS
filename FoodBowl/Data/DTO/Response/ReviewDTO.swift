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
    
    func toReview() -> Review {
        return Review(
            reviews: self.reviews.map { $0.toReviewItem() },
            page: self.page.toPage()
        )
    }
}

// MARK: - PageDTO
struct PageDTO: Codable {
    let firstId, lastId: Int?
    let size: Int
    
    func toPage() -> Page {
        return Page(
            firstId: self.firstId,
            lastId: self.lastId,
            size: self.size
        )
    }
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
    
    func toReviewItem() -> ReviewItem {
        return ReviewItem(
            writer: self.writer.toWriter(),
            comment: self.review.toComment(),
            store: self.store.toStore()
        )
    }
}

// MARK: - CommentDTO
struct CommentDTO: Codable {
    let id: Int
    let content: String
    let imagePaths: [String]
    let createdAt: String
    let updatedAt: String
    
    func toComment() -> Comment {
        return Comment(
            id: self.id,
            content: self.content,
            imagePaths: self.imagePaths,
            createdAt: self.createdAt,
            updatedAt: self.updatedAt
        )
    }
}

// MARK: - StoreByReviewDTO
struct StoreByReviewDTO: Codable {
    let id: Int
    let categoryName, name, addressName: String
    let distance: Double
    var isBookmarked: Bool
    
    func toStore() -> Store {
        return Store(
            id: self.id,
            categoryName: self.categoryName,
            name: self.name,
            addressName: self.addressName,
            isBookmarked: self.isBookmarked,
            distance: self.distance,
            url: nil,
            x: nil,
            y: nil,
            reviewCount: nil
        )
    }
}

// MARK: - WriterItemDTO
struct WriterItemDTO: Codable {
    let id: Int
    let nickname: String
    let profileImageUrl: String?
    let followerCount: Int
    
    func toWriter() -> Writer {
        return Writer(
            id: self.id,
            nickname: self.nickname,
            profileImageUrl: self.profileImageUrl,
            followerCount: self.followerCount
        )
    }
}
