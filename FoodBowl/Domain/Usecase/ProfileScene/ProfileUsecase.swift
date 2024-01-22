//
//  ProfileUsecase.swift
//  FoodBowl
//
//  Created by Coby on 1/22/24.
//

import Foundation

protocol ProfileUsecase {
    func getMemberProfile(id: Int) async throws -> Member
    func getReviewsByMember(request: GetReviewsByMemberRequestDTO) async throws -> Reviews
    func getStoresByMember(request: GetStoresByMemberRequestDTO) async throws -> [Store]
    func removeReview(id: Int) async throws
    func createBookmark(storeId: Int) async throws
    func removeBookmark(storeId: Int) async throws
    func followMember(memberId: Int) async throws
    func unfollowMember(memberId: Int) async throws
}

final class ProfileUsecaseImpl: ProfileUsecase {
    
    // MARK: - property
    
    private let repository: ProfileRepository
    
    // MARK: - init
    
    init(repository: ProfileRepository) {
        self.repository = repository
    }
    
    // MARK: - Public - func
    
    func getMemberProfile(id: Int) async throws -> Member {
        do {
            let MemberProfileDTO = try await self.repository.getMemberProfile(id: id)
            return MemberProfileDTO.toMember()
        } catch(let error) {
            throw error
        }
    }
    
    func getReviewsByMember(request: GetReviewsByMemberRequestDTO) async throws -> Reviews {
        do {
            let reviewDTO = try await self.repository.getReviewsByMember(request: request)
            return reviewDTO.toReviews()
        } catch(let error) {
            throw error
        }
    }
    
    func getStoresByMember(request: GetStoresByMemberRequestDTO) async throws -> [Store] {
        do {
            let storeDTO = try await self.repository.getStoresByMember(request: request)
            return storeDTO.stores.map { $0.toStore() }
        } catch(let error) {
            throw error
        }
    }
    
    func removeReview(id: Int) async throws {
        do {
            try await self.repository.removeReview(id: id)
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
