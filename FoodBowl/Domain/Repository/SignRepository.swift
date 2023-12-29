//
//  SignRepository.swift
//  FoodBowl
//
//  Created by Coby on 12/29/23.
//

import Foundation

protocol SignRepository {
    func checkNickname(nickname: String) async throws -> CheckNicknameDTO
    func signIn(request: SignRequestDTO) async throws -> TokenDTO
    func logOut() async throws
}
