//
//  UnivUsecase.swift
//  FoodBowl
//
//  Created by Coby on 1/22/24.
//

import Foundation

protocol UnivUsecase {
    func getReviewsBySchool(request: GetReviewsBySchoolRequestDTO) async throws -> Reviews
    func getStoresBySchool(request: GetStoresBySchoolRequestDTO) async throws -> [Store]
    func createBookmark(storeId: Int) async throws
    func removeBookmark(storeId: Int) async throws
}

final class UnivUsecaseImpl: UnivUsecase {
    
    // MARK: - property
    
    private let repository: UnivRepository
    
    // MARK: - init
    
    init(repository: UnivRepository) {
        self.repository = repository
    }
    
    // MARK: - Public - func
    
    func getReviewsBySchool(request: GetReviewsBySchoolRequestDTO) async throws -> Reviews {
        do {
            let reviewDTO = try await self.repository.getReviewsBySchool(request: request)
            return reviewDTO.toReviews()
        } catch(let error) {
            throw error
        }
    }
    
    func getStoresBySchool(request: GetStoresBySchoolRequestDTO) async throws -> [Store] {
        do {
            let storeDTO = try await self.repository.getStoresBySchool(request: request)
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
}
