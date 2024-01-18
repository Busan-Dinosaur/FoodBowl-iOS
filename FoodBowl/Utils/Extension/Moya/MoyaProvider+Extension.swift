//
//  MoyaProvider+Extension.swift
//  FoodBowl
//
//  Created by COBY_PRO on 2023/08/10.
//

import Foundation

import Moya

extension MoyaProvider {
    func request(_ target: Target) async -> Result<Response, MoyaError> {
        await withCheckedContinuation { continuation in
            self.request(target) { result in
                continuation.resume(returning: result)
            }
        }
    }
}

extension MoyaError {
    var errorResponse: ErrorDTO? {
        if let response = response {
            do {
                return try response.map(ErrorDTO.self)
            } catch {
                print("에러 데이터 매핑에 실패했습니다.")
                return nil
            }
        }
        return nil
    }
}
