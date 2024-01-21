//
//  EditProfileUsecase.swift
//  FoodBowl
//
//  Created by Coby on 1/21/24.
//

import Foundation

protocol EditProfileUsecase {
    func getMemberProfile(id: Int) async throws -> Member
    func updateMemberProfile(request: UpdateMemberProfileRequestDTO) async throws
    func updateMemberProfileImage(image: Data) async throws
}

final class EditProfileUsecaseImpl: EditProfileUsecase {
    
    // MARK: - property
    
    private let repository: EditProfileRepository
    
    // MARK: - init
    
    init(repository: EditProfileRepository) {
        self.repository = repository
    }
    
    // MARK: - Public - func
    
    func getMemberProfile(id: Int) async throws -> Member {
        do {
            let memberProfileDTO = try await self.repository.getMemberProfile(id: id)
            return memberProfileDTO.toMember()
        } catch(let error) {
            throw error
        }
    }
    
    func updateMemberProfile(request: UpdateMemberProfileRequestDTO) async throws {
        do {
            try await self.repository.updateMemberProfile(request: request)
        } catch(let error) {
            throw error
        }
    }
    
    func updateMemberProfileImage(image: Data) async throws {
        do {
            try await self.repository.updateMemberProfileImage(image: image)
        } catch(let error) {
            throw error
        }
    }
}
