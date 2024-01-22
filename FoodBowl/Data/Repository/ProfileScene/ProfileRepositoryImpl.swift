//
//  ProfileRepositoryImpl.swift
//  FoodBowl
//
//  Created by Coby on 1/22/24.
//

import Foundation

import Moya

final class ProfileRepositoryImpl: ProfileRepository {
    
    private let provider = MoyaProvider<ServiceAPI>()
    
    func getMemberProfile(id: Int) async throws -> MemberProfileDTO {
        let response = await provider.request(.getMemberProfile(id: id))
        return try response.decode()
    }
    
    func getReviewsByMember(request: GetReviewsByMemberRequestDTO) async throws -> ReviewDTO {
        let response = await provider.request(.getReviewsByMember(request: request))
        return try response.decode()
    }
    
    func getStoresByMember(request: GetStoresByMemberRequestDTO) async throws -> StoreDTO {
        let response = await provider.request(.getStoresByMember(request: request))
        return try response.decode()
    }

    func removeReview(id: Int) async throws {
        let _ = await provider.request(.removeReview(id: id))
    }
    
    func createBookmark(storeId: Int) async throws {
        let _ = await provider.request(.createBookmark(storeId: storeId))
    }
    
    func removeBookmark(storeId: Int) async throws {
        let _ = await provider.request(.removeBookmark(storeId: storeId))
    }
    
    func followMember(memberId: Int) async throws {
        let _ = await provider.request(.followMember(memberId: memberId))
    }
    
    func unfollowMember(memberId: Int) async throws {
        let _ = await provider.request(.unfollowMember(memberId: memberId))
    }
}
