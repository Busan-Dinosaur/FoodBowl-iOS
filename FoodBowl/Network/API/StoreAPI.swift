//
//  StoreAPI.swift
//  FoodBowl
//
//  Created by COBY_PRO on 2023/09/10.
//

import Foundation

import Moya

enum StoreAPI {
    case addBookmark(storeId: Int)
    case removeBookmark(storeId: Int)
    case createReview(form: CreateReviewRequest)
    case removeReview(id: Int)
    case getSchools
    case getCategories
}

extension StoreAPI: TargetType {
    var baseURL: URL {
        @Configurations(key: ConfigurationsKey.baseURL, defaultValue: "")
        var baseURL: String
        return URL(string: baseURL)!
    }

    var path: String {
        switch self {
        case .addBookmark, .removeBookmark:
            return "/v1/bookmarks"
        case .createReview, .removeReview:
            return "/v1/reviews"
        case .getSchools:
            return "/v1/stores/schools"
        case .getCategories:
            return "/v1/stores/categories"
        }
    }

    var method: Moya.Method {
        switch self {
        case .addBookmark, .createReview:
            return .post
        case .removeBookmark, .removeReview:
            return .delete
        default:
            return .get
        }
    }

    var task: Task {
        switch self {
        case .addBookmark(let storeId):
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
        case .createReview(let form):
            return .requestJSONEncodable(form)
        case .removeReview(let id):
            let params: [String: Int] = [
                "id": id
            ]
            return .requestParameters(
                parameters: params,
                encoding: URLEncoding.default
            )
        case .getSchools, .getCategories:
            return .requestPlain
        }
    }

    var headers: [String: String]? {
        let accessToken: String = KeychainManager.get(.accessToken)

        return [
            "Content-Type": "application/json",
            "Authorization": "Bearer " + accessToken
        ]
    }

    var validationType: ValidationType { .successCodes }
}
