//
//  EditProfileRepository.swift
//  FoodBowl
//
//  Created by Coby on 1/21/24.
//

import Foundation

protocol EditProfileRepository {
    func getMemberProfile(id: Int) async throws -> MemberProfileDTO
    func updateMemberProfile(request: UpdateMemberProfileRequestDTO) async throws
    func updateMemberProfileImage(image: Data) async throws
}
