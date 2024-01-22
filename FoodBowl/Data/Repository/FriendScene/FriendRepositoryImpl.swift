//
//  FriendRepositoryImpl.swift
//  FoodBowl
//
//  Created by Coby on 1/22/24.
//

import Foundation

import Moya

final class FriendRepositoryImpl: FriendRepository {
    
    private let provider = MoyaProvider<ServiceAPI>()
    
    func getReviewsByFollowing(request: GetReviewsRequestDTO) async throws -> ReviewDTO {
        let response = await provider.request(.getReviewsByFollowing(request: request))
        return try response.decode()
    }
    
    func getReviewsByBookmark(request: GetReviewsRequestDTO) async throws -> ReviewDTO {
        let response = await provider.request(.getReviewsByBookmark(request: request))
        return try response.decode()
    }
    
    func getStoresByFollowing(request: CustomLocationRequestDTO) async throws -> StoreDTO {
        let response = await provider.request(.getStoresByFollowing(request: request))
        return try response.decode()
    }
    
    func getStoresByBookmark(request: CustomLocationRequestDTO) async throws -> StoreDTO {
        let response = await provider.request(.getStoresByBookmark(request: request))
        return try response.decode()
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
