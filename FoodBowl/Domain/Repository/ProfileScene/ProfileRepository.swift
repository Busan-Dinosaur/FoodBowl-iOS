//
//  ProfileRepository.swift
//  FoodBowl
//
//  Created by Coby on 1/22/24.
//

import Foundation

protocol ProfileRepository {
    func getMemberProfile(id: Int) async throws -> MemberProfileDTO
    func getReviewsByMember(request: GetReviewsByMemberRequestDTO) async throws -> ReviewDTO
    func getStoresByMember(request: GetStoresByMemberRequestDTO) async throws -> StoreDTO
    func removeReview(id: Int) async throws
    func createBookmark(storeId: Int) async throws
    func removeBookmark(storeId: Int) async throws
    func followMember(memberId: Int) async throws
    func unfollowMember(memberId: Int) async throws
}
