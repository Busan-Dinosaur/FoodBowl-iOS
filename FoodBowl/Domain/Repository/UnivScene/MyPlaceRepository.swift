//
//  UnivRepository.swift
//  FoodBowl
//
//  Created by Coby on 1/22/24.
//

import Foundation

protocol MyPlaceRepository {
    func getReviewsByBound(request: GetReviewsRequestDTO) async throws -> ReviewDTO
    func getStoresByBound(request: CustomLocationRequestDTO) async throws -> StoreDTO
    func createBookmark(storeId: Int) async throws
    func removeBookmark(storeId: Int) async throws
}
