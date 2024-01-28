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
            do {
                let data = try result.map(T.self)
                return data
            } catch {
                do {
                    let errorMessage = try result.map(ErrorDTO.self).message
                    throw CustomError.error(message: errorMessage)
                } catch {
                    throw CustomError.unknownError
                }
            }
        case .failure:
            throw CustomError.unknownError
        }
    }
}
