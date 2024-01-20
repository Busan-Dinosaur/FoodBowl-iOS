//
//  SignUsecase.swift
//  FoodBowl
//
//  Created by COBY_PRO on 11/9/23.
//

import Foundation

protocol SignUsecase {
    func dispatchAppleLogin(login: SignRequestDTO) async throws -> TokenDTO
    func getMyProfile() async throws -> MemberProfileDTO
}

final class SignUsecaseImpl: SignUsecase {
    
    // MARK: - property
    
    private let repository: SignRepository
    
    // MARK: - init
    
    init(repository: SignRepository) {
        self.repository = repository
    }
    
    // MARK: - Public - func
    
    func dispatchAppleLogin(login: SignRequestDTO) async throws -> TokenDTO {
        do {
            let tokenDTO = try await self.repository.signIn(request: login)
            return tokenDTO
        } catch(let error) {
            throw error
        }
    }
    
    func getMyProfile() async throws -> MemberProfileDTO {
        do {
            let MemberProfileDTO = try await self.repository.getMyProfile()
            return MemberProfileDTO
        } catch(let error) {
            throw error
        }
    }
}
