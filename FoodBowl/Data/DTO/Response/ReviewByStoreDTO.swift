//
//  ReviewByStoreDTO.swift
//  FoodBowl
//
//  Created by Coby on 1/17/24.
//

import Foundation

// MARK: - ReviewByStoreDTO
struct ReviewByStoreDTO: Codable {
    let storeReviewContentResponses: [ReviewItemByStoreDTO]
    let page: PageDTO
    
    func toReview() -> Review {
        return Review(
            reviews: self.storeReviewContentResponses.map { $0.toReviewItem() },
            page: self.page.toPage()
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
