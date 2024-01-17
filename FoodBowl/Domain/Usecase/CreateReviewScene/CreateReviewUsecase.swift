//
//  CreateReviewUsecase.swift
//  FoodBowl
//
//  Created by Coby on 1/18/24.
//

import Foundation

protocol CreateReviewUsecase {
    func searchStores(x: String, y: String, keyword: String) async throws -> [PlaceItemDTO]
    func searchUniv(x: String, y: String) async throws -> PlaceItemDTO?
    func createReview(request: CreateReviewRequestDTO) async throws
}

final class CreateReviewUsecaseImpl: CreateReviewUsecase {
    
    // MARK: - property
    
    private let repository: CreateReviewRepository
    
    // MARK: - init
    
    init(repository: CreateReviewRepository) {
        self.repository = repository
    }
    
    // MARK: - Public - func
    
    func searchStores(x: String, y: String, keyword: String) async throws -> [PlaceItemDTO] {
        do {
            let placeDTO = try await self.repository.searchStores(x: x, y: y, keyword: keyword)
            return placeDTO.documents
        } catch {
            throw NetworkError()
        }
    }
    
    func searchUniv(x: String, y: String) async throws -> PlaceItemDTO? {
        do {
            let placeDTO = try await self.repository.searchUniv(x: x, y: y)
            return placeDTO.documents.filter { $0.placeName.contains("대학교") || $0.placeName.contains("캠퍼스") }.first
        } catch {
            throw NetworkError()
        }
    }
    
    func createReview(request: CreateReviewRequestDTO) async throws {
        do {
            try await self.repository.createReview(request: request)
        } catch {
            throw NetworkError()
        }
    }
}
