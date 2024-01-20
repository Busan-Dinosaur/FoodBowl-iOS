//
//  ReviewByStoreDTO.swift
//  FoodBowl
//
//  Created by Coby on 1/17/24.
//

import Foundation

// MARK: - ReviewByStoreDTO
struct ReviewByStoreDTO: Codable {
    let reviewStoreResponse: StoreDetailDTO
    let storeReviewContentResponses: [ReviewItemByStoreDTO]
    let page: PageDTO
    
    func toReview() -> Review {
        Review(
            reviews: self.storeReviewContentResponses.map { $0.toReviewItem() },
            page: self.page.toPage()
        )
    }
}

// MARK: - StoreDetailDTO
struct StoreDetailDTO: Codable {
    let id: Int
    let categoryName: String
    let name: String
    let addressName: String
    let distance: Double
    let isBookmarked: Bool
    
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
    
    func toReviewItem() -> ReviewItem {
        ReviewItem(
            member: self.writer.toMember(),
            comment: self.review.toComment(),
            store: nil,
            thumbnail: ""
        )
    }
}
