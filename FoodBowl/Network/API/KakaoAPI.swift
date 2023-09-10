//
//  KakaoAPI.swift
//  FoodBowl
//
//  Created by COBY_PRO on 2023/09/10.
//

import Foundation

import Moya

enum KakaoAPI {
    case searchStores(x: String, y: String, keyword: String)
    case searchUniv(x: String, y: String)
}

extension KakaoAPI: TargetType {
    var baseURL: URL {
        @Configurations(key: ConfigurationsKey.kakaoURL, defaultValue: "")
        var kakaoURL: String
        return URL(string: kakaoURL)!
    }

    var path: String {
        switch self {
        case .searchStores, .searchUniv:
            return "/v2/local/search/keyword"
        }
    }

    var method: Moya.Method {
        switch self {
        default:
            return .get
        }
    }

    var task: Task {
        switch self {
        case .searchStores(let x, let y, let keyword):
            let params: [String: Any] = [
                "query": keyword,
                "x": x,
                "y": y,
                "page": 1,
                "size": 15,
                "category_group_code": "FD6,CE7"
            ]
            return .requestParameters(
                parameters: params,
                encoding: URLEncoding.default
            )
        case .searchUniv(let x, let y):
            let params: [String: Any] = [
                "query": "대학교",
                "x": x,
                "y": y,
                "page": 1,
                "size": 1,
                "radius": 3000,
                "category_group_code": "SC4"
            ]
            return .requestParameters(
                parameters: params,
                encoding: URLEncoding.default
            )
        }
    }

    var headers: [String: String]? {
        @Configurations(key: ConfigurationsKey.kakaoToken, defaultValue: "")
        var kakaoToken: String

        return [
            "Content-Type": "application/x-www-form-urlencoded;charset=utf-8",
            "Authorization": "KakaoAK " + kakaoToken
        ]
    }

    var validationType: ValidationType { .successCodes }
}
