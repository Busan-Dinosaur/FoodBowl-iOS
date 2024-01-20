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
        Review(
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
        Page(
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
        ReviewItem(
            writer: self.writer.toWriter(),
            comment: self.review.toComment(),
            store: self.store.toStore(),
            thumbnail: ""
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
        Comment(
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
        Store(
            id: self.id,
            category: self.categoryName,
            name: self.name,
            address: self.addressName,
            isBookmark: self.isBookmarked,
            distance: self.distance.prettyDistance,
            url: "",
            x: 0.0,
            y: 0.0,
            reviewCount: ""
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
        Writer(
            id: self.id,
            nickname: self.nickname,
            profileImageUrl: self.profileImageUrl,
            followerCount: self.followerCount
        )
    }
}
