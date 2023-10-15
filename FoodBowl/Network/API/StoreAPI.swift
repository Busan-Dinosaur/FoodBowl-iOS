//
//  StoreAPI.swift
//  FoodBowl
//
//  Created by COBY_PRO on 2023/09/10.
//

import UIKit

import Moya

enum StoreAPI {
    case getStoresBySearch(form: SearchStoresRequest)
    case getStoresBySchool(form: CustomLocation, schoolId: Int)
    case getStoresByMember(form: CustomLocation, memberId: Int)
    case getStoresByFollowing(form: CustomLocation)
    case getStoresByBookmark(form: CustomLocation)
}

extension StoreAPI: TargetType {
    var baseURL: URL {
        @Configurations(key: ConfigurationsKey.baseURL, defaultValue: "")
        var baseURL: String
        return URL(string: baseURL)!
    }

    var path: String {
        switch self {
        case .getStoresBySearch:
            return "/v1/stores/search"
        case .getStoresBySchool:
            return "/v1/stores/schools"
        case .getStoresByMember:
            return "/v1/stores/members"
        case .getStoresByFollowing:
            return "/v1/stores/followings"
        case .getStoresByBookmark:
            return "/v1/stores/bookmarks"
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
        case .getStoresBySearch(let form):
            var params: [String: Any] = [
                "name": form.name,
                "x": form.x,
                "y": form.y
            ]
            
            if let size = form.size {
                params["size"] = size
            }
            
            return .requestParameters(
                parameters: params,
                encoding: URLEncoding.default
            )
        case .getStoresBySchool(let form, let schoolId):
            let params: [String: Any] = [
                "schoolId": schoolId,
                "x": form.x,
                "y": form.y,
                "deltaX": form.deltaX,
                "deltaY": form.deltaY
            ]
            return .requestParameters(
                parameters: params,
                encoding: URLEncoding.default
            )
        case .getStoresByMember(let form, let memberId):
            let params: [String: Any] = [
                "memberId": memberId,
                "x": form.x,
                "y": form.y,
                "deltaX": form.deltaX,
                "deltaY": form.deltaY
            ]
            return .requestParameters(
                parameters: params,
                encoding: URLEncoding.default
            )
        case .getStoresByFollowing(let form):
            let params: [String: Any] = [
                "x": form.x,
                "y": form.y,
                "deltaX": form.deltaX,
                "deltaY": form.deltaY
            ]
            return .requestParameters(
                parameters: params,
                encoding: URLEncoding.default
            )
        case .getStoresByBookmark(let form):
            let params: [String: Any] = [
                "x": form.x,
                "y": form.y,
                "deltaX": form.deltaX,
                "deltaY": form.deltaY
            ]
            return .requestParameters(
                parameters: params,
                encoding: URLEncoding.default
            )
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
