//
//  ReviewDetailUsecase.swift
//  FoodBowl
//
//  Created by Coby on 1/24/24.
//

import Foundation

protocol ReviewDetailUsecase {
    func getReview(request: GetReviewRequestDTO) async throws -> Review
}

final class ReviewDetailUsecaseImpl: ReviewDetailUsecase {
    
    // MARK: - property
    
    private let repository: ReviewDetailRepository
    
    // MARK: - init
    
    init(repository: ReviewDetailRepository) {
        self.repository = repository
    }
    
    // MARK: - Public - func
    
    func getReview(request: GetReviewRequestDTO) async throws -> Review {
        do {
            let reviewItemDTO = try await self.repository.getReview(request: request)
            return reviewItemDTO.toReview()
        } catch(let error) {
            throw error
        }
    }
}
