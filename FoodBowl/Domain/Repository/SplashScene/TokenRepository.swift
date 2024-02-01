//
//  TokenRepository.swift
//  FoodBowl
//
//  Created by Coby on 12/29/23.
//

import Foundation

protocol TokenRepository {
    func patchRefreshToken(token: Token) async throws -> Token
}
