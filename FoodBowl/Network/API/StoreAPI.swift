//
//  StoreAPI.swift
//  FoodBowl
//
//  Created by COBY_PRO on 2023/09/10.
//

import UIKit

import Moya

enum StoreAPI {
    case addBookmark(storeId: Int)
    case removeBookmark(storeId: Int)
    case createReview(request: CreateReviewRequest)
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
        case .getSchools, .getCategories:
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
        case .createReview(let request):
            var multipartFormData = [MultipartFormData]()

            if let reviewData = try? JSONEncoder().encode(request.request) {
                multipartFormData.append(
                    MultipartFormData(
                        provider: .data(reviewData),
                        name: "request",
                        mimeType: "application/json"
                    )
                )
            }

            for image in request.images {
                multipartFormData.append(
                    MultipartFormData(
                        provider: .data(image),
                        name: "images[]",
                        fileName: "\(request.request.storeName)_\(UUID().uuidString).jpg",
                        mimeType: "image/jpeg"
                    )
                )
            }

            return .uploadMultipart(multipartFormData)
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

        switch self {
        case .createReview:
            return [
                "Content-Type": "application/json",
                "Content-type": "multipart/form-data",
                "Authorization": "Bearer " + accessToken
            ]
        default:
            return [
                "Content-Type": "application/json",
                "Authorization": "Bearer " + accessToken
            ]
        }
    }

    var validationType: ValidationType { .successCodes }
}
