//
//  ServiceAPI.swift
//  FoodBowl
//
//  Created by COBY_PRO on 10/12/23.
//

import Foundation

import Moya

enum ServiceAPI {
    case signIn(request: SignRequest)
    case renew
    case checkNickname(nickname: String)
    case createBookmark(storeId: Int)
    case removeBookmark(storeId: Int)
    case getSchools
    case getCategories
    case createBlame(request: CreateBlameRequest)
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
        case .renew:
            return "/v1/auth/token/renew"
        case .checkNickname:
            return "/v1/members/nickname/exist"
        case .createBookmark, .removeBookmark:
            return "/v1/bookmarks"
        case .getSchools:
            return "/v1/schools"
        case .getCategories:
            return "/v1/stores/categories"
        case .createBlame:
            return "/v1/blames"
        }
    }

    var method: Moya.Method {
        switch self {
        case .signIn, .renew, .createBookmark, .createBlame:
            return .post
        case .removeBookmark:
            return .delete
        default:
            return .get
        }
    }

    var task: Task {
        switch self {
        case .signIn(let request):
            return .requestJSONEncodable(request)
        case .renew:
            let form = RenewRequest(
                accessToken: KeychainManager.get(.accessToken),
                refreshToken: KeychainManager.get(.refreshToken)
            )
            return .requestJSONEncodable(form)
        case .checkNickname(let nickname):
            let params: [String: String] = [
                "nickname": nickname
            ]
            return .requestParameters(
                parameters: params,
                encoding: URLEncoding.default
            )
        case .createBookmark(let storeId):
            let params: [String: Int] = [
                "storeId": storeId
            ]
            return .requestParameters(
                parameters: params,
                encoding: URLEncoding.default
            )
        case .removeBookmark(let storeId):
            let params: [String: Int] = [
                "storeId": storeId
            ]
            return .requestParameters(
                parameters: params,
                encoding: URLEncoding.default
            )
        case .createBlame(let request):
            return .requestJSONEncodable(request)
        default:
            return .requestPlain
        }
    }

    var headers: [String: String]? {
        switch self {
        case .signIn:
            return [
                "Content-Type": "application/json"
            ]
        default:
            let accessToken: String = KeychainManager.get(.accessToken)

            return [
                "Content-Type": "application/json",
                "Authorization": "Bearer " + accessToken
            ]
        }
    }

    var validationType: ValidationType { .successCodes }
}
