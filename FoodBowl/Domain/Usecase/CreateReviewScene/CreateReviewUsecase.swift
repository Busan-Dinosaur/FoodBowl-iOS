//
//  CreateReviewUsecase.swift
//  FoodBowl
//
//  Created by Coby on 1/18/24.
//

import Foundation

protocol CreateReviewUsecase {
    func searchStores(x: String, y: String, keyword: String) async throws -> [Place]
    func searchUniv(x: String, y: String) async throws -> Place?
    func createReview(request: CreateReviewRequestDTO, images: [Data]) async throws
}

final class CreateReviewUsecaseImpl: CreateReviewUsecase {
    
    // MARK: - property
    
    private let repository: CreateReviewRepository
    
    // MARK: - init
    
    init(repository: CreateReviewRepository) {
        self.repository = repository
    }
    
    // MARK: - Public - func
    
    func searchStores(x: String, y: String, keyword: String) async throws -> [Place] {
        do {
            let placeDTO = try await self.repository.searchStores(x: x, y: y, keyword: keyword)
            return placeDTO.documents.map { $0.toPlace() }
        } catch {
            throw NetworkError()
        }
    }
    
    func searchUniv(x: String, y: String) async throws -> Place? {
        do {
            let placeDTO = try await self.repository.searchUniv(x: x, y: y)
            return placeDTO.documents.filter { $0.placeName.contains("대학교") || $0.placeName.contains("캠퍼스") }.first?.toPlace()
        } catch {
            throw NetworkError()
        }
    }
    
    func createReview(request: CreateReviewRequestDTO, images: [Data]) async throws {
        do {
            try await self.repository.createReview(request: request, images: images)
        } catch {
            throw NetworkError()
        }
    }
}
