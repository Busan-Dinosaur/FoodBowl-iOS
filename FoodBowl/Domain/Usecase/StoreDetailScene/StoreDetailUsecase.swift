//
//  StoreDetailUsecase.swift
//  FoodBowl
//
//  Created by Coby on 1/17/24.
//

import Foundation

protocol StoreDetailUsecase {
    func getReviewsByStore(request: GetReviewsByStoreRequestDTO) async throws -> ReviewByStoreDTO
    func removeReview(id: Int) async throws
    func createBookmark(storeId: Int) async throws
    func removeBookmark(storeId: Int) async throws
}

final class StoreDetailUsecaseImpl: StoreDetailUsecase {
    
    // MARK: - property
    
    private let repository: StoreDetailRepository
    
    // MARK: - init
    
    init(repository: StoreDetailRepository) {
        self.repository = repository
    }
    
    // MARK: - Public - func
    
    func getReviewsByStore(request: GetReviewsByStoreRequestDTO) async throws -> ReviewByStoreDTO {
        do {
            let reviewByStoreDTO = try await self.repository.getReviewsByStore(request: request)
            return reviewByStoreDTO
        } catch {
            throw NetworkError()
        }
    }
    
    func removeReview(id: Int) async throws {
        do {
            try await self.repository.removeReview(id: id)
        } catch {
            throw NetworkError()
        }
    }
    
    func createBookmark(storeId: Int) async throws {
        do {
            try await self.repository.createBookmark(storeId: storeId)
        } catch {
            throw NetworkError()
        }
    }
    
    func removeBookmark(storeId: Int) async throws {
        do {
            try await self.repository.removeBookmark(storeId: storeId)
        } catch {
            throw NetworkError()
        }
    }
}
