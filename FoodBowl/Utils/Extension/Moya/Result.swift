//
//  Result.swift
//  FoodBowl
//
//  Created by Coby on 12/29/23.
//

import Foundation

import Moya

public extension Result<Response, MoyaError> {
    
    func decode<T: Decodable>() throws -> T {
        switch self {
        case .success(let result):
            guard let data = try? result.map(T.self) else {
                do {
                    let errorMessage = try result.map(ErrorDTO.self).message
                    throw NetworkError(errorMessage)
                } catch {
                    throw NetworkError("네트워크 통신에 실패하였습니다.")
                }
            }
            return data
        case .failure:
            throw NetworkError("네트워크 통신에 실패하였습니다.")
        }
    }
}
