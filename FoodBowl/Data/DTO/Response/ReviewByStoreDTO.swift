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
        return Review(
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
        return ReviewItem(
            writer: self.writer.toWriter(),
            comment: self.review.toComment(),
            store: nil
        )
    }
}
