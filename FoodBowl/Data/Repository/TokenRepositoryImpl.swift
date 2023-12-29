//
//  TokenRepositoryImpl.swift
//  FoodBowl
//
//  Created by Coby on 12/29/23.
//

import Foundation

import Moya

final class TokenRepositoryImpl: TokenRepository {

    private let provider = MoyaProvider<ServiceAPI>()

    func patchRefreshToken(token: TokenDTO) async throws -> TokenDTO {
        let response = await provider.request(.patchRefreshToken(token: token))
        
        switch response {
        case .success(let result):
            guard let data = try? result.map(TokenDTO.self) else {
                do {
                    let errorMessage = try result.map(ErrorDTO.self).message
                    throw NetworkError(errorMessage)
                } catch {
                    throw NetworkError("네트워크 통신에 실패하였습니다.")
                }
            }
            return data
        case .failure(let err):
            throw NetworkError("네트워크 통신에 실패하였습니다.")
        }
    }
}
