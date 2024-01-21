//
//  EditProfileRepositoryImpl.swift
//  FoodBowl
//
//  Created by Coby on 1/21/24.
//

import Foundation

import Moya

final class EditProfileRepositoryImpl: EditProfileRepository {
    
    private let provider = MoyaProvider<ServiceAPI>()
    
    func getMyProfile() async throws -> MemberProfileDTO {
        let response = await provider.request(.getMyProfile)
        return try response.decode()
    }
    
    func updateMemberProfile(request: UpdateMemberProfileRequestDTO) async throws {
        let _ = await provider.request(.updateMemberProfile(request: request))
    }
    
    func updateMemberProfileImage(image: Data) async throws {
        let _ = await provider.request(.updateMemberProfileImage(image: image))
    }
}
