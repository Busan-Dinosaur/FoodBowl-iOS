//
//  UpdateReviewRepository.swift
//  FoodBowl
//
//  Created by Coby on 1/22/24.
//

import Foundation

protocol UpdateReviewRepository {
    func updateReview(id: Int, request: UpdateReviewRequestDTO, images: [Data]) async throws
}
