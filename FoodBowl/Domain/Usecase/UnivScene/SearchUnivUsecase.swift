//
//  SearchUnivUsecase.swift
//  FoodBowl
//
//  Created by Coby on 1/22/24.
//

protocol SearchUnivUsecase {
    func getSchools() async throws -> [Store]
}

final class SearchUnivUsecaseImpl: SearchUnivUsecase {
    
    // MARK: - property
    
    private let repository: SearchUnivRepository
    
    // MARK: - init
    
    init(repository: SearchUnivRepository) {
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
