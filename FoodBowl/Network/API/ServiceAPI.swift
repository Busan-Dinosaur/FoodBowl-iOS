//
//  ServiceAPI.swift
//  FoodBowl
//
//  Created by COBY_PRO on 2023/08/09.
//

import Foundation

import Moya

enum ServiceAPI {
    case signIn(appleToken: String)
}

extension ServiceAPI: TargetType {
    var baseURL: URL {
        @Configurations(key: ConfigurationsKey.baseURL, defaultValue: "")
        var baseURL: String
        return URL(string: baseURL)!
    }

    var path: String {
        switch self {
        case .signIn:
            return "/v1/auth/login/oauth/apple"
        }
    }

    var method: Moya.Method {
        switch self {
        case .signIn:
            return .post
        default:
            return .get
        }
    }

    var task: Task {
        switch self {
        case .signIn(let appleToken):
            let params: [String: String] = [
                "appleToken": appleToken
            ]
            return .requestParameters(
                parameters: params,
                encoding: URLEncoding.default
            )
        }
    }

    var headers: [String: String]? {
        switch self {
        case .signIn:
            return [
                "Content-Type": "application/json"
            ]
        default:
            let token: String = KeychainManager.get(.token)

            return [
                "Content-Type": "application/json",
                "Authorization": token
            ]
        }
    }

    var validationType: ValidationType { .successCodes }
}
