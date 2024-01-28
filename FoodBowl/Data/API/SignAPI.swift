//
//  SignAPI.swift
//  FoodBowl
//
//  Created by Coby on 1/29/24.
//

import Foundation

import Moya

enum SignAPI {
    case signIn(request: SignRequestDTO)
}

extension SignAPI: TargetType {
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
        }
    }

    var task: Task {
        switch self {
        case .signIn(let request):
            return .requestJSONEncodable(request)
        }
    }

    var headers: [String: String]? {
        switch self {
        case .signIn:
            return [
                "Content-Type": "application/json"
            ]
        }
    }

    var validationType: ValidationType { .successCodes }
}
