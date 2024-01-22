//
//  FriendUsecase.swift
//  FoodBowl
//
//  Created by Coby on 1/22/24.
//

import Foundation

protocol FriendUsecase {
    func getReviewsByFollowing(request: GetReviewsRequestDTO) async throws -> Reviews
    func getReviewsByBookmark(request: GetReviewsRequestDTO) async throws -> Reviews
    func getStoresByFollowing(request: CustomLocationRequestDTO) async throws -> [Store]
    func getStoresByBookmark(request: CustomLocationRequestDTO) async throws -> [Store]
    func createBookmark(storeId: Int) async throws
    func removeBookmark(storeId: Int) async throws
    func followMember(memberId: Int) async throws
    func unfollowMember(memberId: Int) async throws
}

final class FriendUsecaseImpl: FriendUsecase {
    
    // MARK: - property
    
    private let repository: FriendRepository
    
    // MARK: - init
    
    init(repository: FriendRepository) {
        self.repository = repository
    }
    
    // MARK: - Public - func
    
    func getReviewsByFollowing(request: GetReviewsRequestDTO) async throws -> Reviews {
        do {
            let reviewDTO = try await self.repository.getReviewsByFollowing(request: request)
            return reviewDTO.toReviews()
        } catch(let error) {
            throw error
        }
    }
    
    func getReviewsByBookmark(request: GetReviewsRequestDTO) async throws -> Reviews {
        do {
            let reviewDTO = try await self.repository.getReviewsByBookmark(request: request)
            return reviewDTO.toReviews()
        } catch(let error) {
            throw error
        }
    }
    
    func getStoresByFollowing(request: CustomLocationRequestDTO) async throws -> [Store] {
        do {
            let storeDTO = try await self.repository.getStoresByFollowing(request: request)
            return storeDTO.stores.map { $0.toStore() }
        } catch(let error) {
            throw error
        }
    }
    
    func getStoresByBookmark(request: CustomLocationRequestDTO) async throws -> [Store] {
        do {
            let storeDTO = try await self.repository.getStoresByBookmark(request: request)
            return storeDTO.stores.map { $0.toStore() }
        } catch(let error) {
            throw error
        }
    }
    
    func createBookmark(storeId: Int) async throws {
        do {
            try await self.repository.createBookmark(storeId: storeId)
        } catch(let error) {
            throw error
        }
    }
    
    func removeBookmark(storeId: Int) async throws {
        do {
            try await self.repository.removeBookmark(storeId: storeId)
        } catch(let error) {
            throw error
        }
    }
    
    func followMember(memberId: Int) async throws {
        do {
            try await self.repository.followMember(memberId: memberId)
        } catch(let error) {
            throw error
        }
    }
    
    func unfollowMember(memberId: Int) async throws {
        do {
            try await self.repository.unfollowMember(memberId: memberId)
        } catch(let error) {
            throw error
        }
    }
}
