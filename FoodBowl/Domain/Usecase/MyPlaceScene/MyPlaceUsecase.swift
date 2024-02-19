//
//  MyPlaceUsecase.swift
//  FoodBowl
//
//  Created by Coby on 1/22/24.
//

import Foundation

protocol MyPlaceUsecase {
    func getReviewsBySchool(request: GetReviewsRequestDTO) async throws -> Reviews
    func getStoresByBound(request: CustomLocationRequestDTO) async throws -> [Store]
    func createBookmark(storeId: Int) async throws
    func removeBookmark(storeId: Int) async throws
}

final class MyPlaceUsecaseImpl: MyPlaceUsecase {
    
    // MARK: - property
    
    private let repository: MyPlaceRepository
    
    // MARK: - init
    
    init(repository: MyPlaceRepository) {
        self.repository = repository
    }
    
    // MARK: - Public - func
    
    func getReviewsBySchool(request: GetReviewsRequestDTO) async throws -> Reviews {
        do {
            let reviewDTO = try await self.repository.getReviewsByBound(request: request)
            return reviewDTO.toReviews()
        } catch(let error) {
            throw error
        }
    }
    
    func getStoresByBound(request: CustomLocationRequestDTO) async throws -> [Store] {
        do {
            let storeDTO = try await self.repository.getStoresByBound(request: request)
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
