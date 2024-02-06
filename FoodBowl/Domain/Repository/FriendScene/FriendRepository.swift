//
//  FriendRepository.swift
//  FoodBowl
//
//  Created by Coby on 1/22/24.
//

import Foundation

protocol FriendRepository {
    func getReviewsByFollowing(request: GetReviewsRequestDTO) async throws -> ReviewDTO
    func getReviewsByBookmark(request: GetReviewsRequestDTO) async throws -> ReviewDTO
    func getStoresByFollowing(request: CustomLocationRequestDTO) async throws -> StoreDTO
    func getStoresByBookmark(request: CustomLocationRequestDTO) async throws -> StoreDTO
    func createBookmark(storeId: Int) async throws
    func removeBookmark(storeId: Int) async throws
}
