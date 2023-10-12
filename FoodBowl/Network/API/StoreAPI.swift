//
//  StoreAPI.swift
//  FoodBowl
//
//  Created by COBY_PRO on 2023/09/10.
//

import UIKit

import Moya

enum StoreAPI {
    case getStoresBySearch(request: SearchStoresRequest)
    case getStoresBySchool(request: GetStoresRequest, schoolId: Int)
    case getStoresByMember(request: GetStoresRequest, memberId: Int)
    case getStoresByFollowing(request: GetStoresRequest)
    case getStoresByBookmark(request: GetStoresRequest)
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
        case .getStoresBySearch(let request):
            let params: [String: Any?] = [
                "name": request.name,
                "x": request.x,
                "y": request.y,
                "size": request.size
            ]
            return .requestParameters(
                parameters: params as [String: Any],
                encoding: URLEncoding.default
            )
        case .getStoresBySchool(let request, let schoolId):
            let params: [String: Any?] = [
                "schoolId": schoolId,
                "x": request.x,
                "y": request.y,
                "deltaX": request.deltaX,
                "deltaY": request.deltaY
            ]
            return .requestParameters(
                parameters: params as [String: Any],
                encoding: URLEncoding.default
            )
        case .getStoresByMember(let request, let memberId):
            let params: [String: Any?] = [
                "memberId": memberId,
                "x": request.x,
                "y": request.y,
                "deltaX": request.deltaX,
                "deltaY": request.deltaY
            ]
            return .requestParameters(
                parameters: params as [String: Any],
                encoding: URLEncoding.default
            )
        case .getStoresByFollowing(let request):
            let params: [String: Any?] = [
                "x": request.x,
                "y": request.y,
                "deltaX": request.deltaX,
                "deltaY": request.deltaY
            ]
            return .requestParameters(
                parameters: params as [String: Any],
                encoding: URLEncoding.default
            )
        case .getStoresByBookmark(let request):
            let params: [String: Any?] = [
                "x": request.x,
                "y": request.y,
                "deltaX": request.deltaX,
                "deltaY": request.deltaY
            ]
            return .requestParameters(
                parameters: params as [String: Any],
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
