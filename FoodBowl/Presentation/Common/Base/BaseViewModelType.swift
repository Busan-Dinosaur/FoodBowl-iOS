//
//  BaseViewModelType.swift
//  FoodBowl
//
//  Created by COBY_PRO on 10/20/23.
//

import Foundation

import Moya

protocol BaseViewModelType {
    associatedtype Input
    associatedtype Output

    func transform(from input: Input) -> Output
}

extension BaseViewModelType {
    func handleError(_ error: MoyaError) {
        if let errorResponse = error.errorResponse {
            print("에러 코드: \(errorResponse.errorCode)")
            print("에러 메시지: \(errorResponse.message)")
        } else {
            print("네트워크 에러: \(error.localizedDescription)")
        }
    }
}
