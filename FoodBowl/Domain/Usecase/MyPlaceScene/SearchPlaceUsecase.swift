//
//  SearchPlaceUsecase.swift
//  FoodBowl
//
//  Created by Coby on 1/22/24.
//

protocol SearchPlaceUsecase {
    func getSchools() async throws -> [Store]
}

final class SearchPlaceUsecaseImpl: SearchPlaceUsecase {
    
    // MARK: - property
    
    private let repository: SearchPlaceRepository
    
    // MARK: - init
    
    init(repository: SearchPlaceRepository) {
        self.repository = repository
    }
    
    // MARK: - Public - func
    
    func getSchools() async throws -> [Store] {
        do {
            let schoolDTO = try await self.repository.getSchools()
            return schoolDTO.schools.map { $0.toStore() }
        } catch(let error) {
            throw error
        }
    }
}
