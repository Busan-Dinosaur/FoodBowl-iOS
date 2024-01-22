//
//  UnivRepository.swift
//  FoodBowl
//
//  Created by Coby on 1/22/24.
//

import Foundation

protocol UnivRepository {
    func getReviewsBySchool(request: GetReviewsBySchoolRequestDTO) async throws -> ReviewDTO
    func getStoresBySchool(request: GetStoresBySchoolRequestDTO) async throws -> StoreDTO
    func createBookmark(storeId: Int) async throws
    func removeBookmark(storeId: Int) async throws
    func followMember(memberId: Int) async throws
    func unfollowMember(memberId: Int) async throws
}
