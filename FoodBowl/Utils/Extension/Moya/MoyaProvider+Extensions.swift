//
//  MoyaProvider+Extensions.swift
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
//                switch result {
//                case let .success(response):
//                    // 성공 시 URL 출력
//                    print(response.request?.url?.absoluteString ?? "URL not available")
//                case let .failure(error):
//                    // 실패 시 URL 출력
//                    print(error.response?.request?.url?.absoluteString ?? "URL not available")
//                }

                // 원래의 결과를 반환
                continuation.resume(returning: result)
            }
        }
    }
}

struct ErrorResponse: Codable {
    let errorCode: String
    let message: String
}

extension MoyaError {
    var errorResponse: ErrorResponse? {
        if let response = response {
            do {
                return try response.map(ErrorResponse.self)
            } catch {
                print("에러 데이터 매핑에 실패했습니다.")
                return nil
            }
        }
        return nil
    }
}
