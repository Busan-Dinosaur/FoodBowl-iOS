//
//  SearchPlaceUsecase.swift
//  FoodBowl
//
//  Created by Coby on 1/22/24.
//

protocol SearchPlaceUsecase {
    func searchPlaces(x: String, y: String, keyword: String) async throws -> [Store]
}

final class SearchPlaceUsecaseImpl: SearchPlaceUsecase {
    
    // MARK: - property
    
    private let repository: SearchPlaceRepository
    
    // MARK: - init
    
    init(repository: SearchPlaceRepository) {
        self.repository = repository
    }
    
    // MARK: - Public - func
    
    func searchPlaces(x: String, y: String, keyword: String) async throws -> [Store] {
        do {
            let placeDTO = try await self.repository.searchPlaces(x: x, y: y, keyword: keyword)
            return placeDTO.documents.map { $0.toStore() }
        } catch(let error) {
            throw error
        }
    }
}
