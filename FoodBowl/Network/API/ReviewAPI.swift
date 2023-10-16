//
//  ReviewAPI.swift
//  FoodBowl
//
//  Created by COBY_PRO on 10/12/23.
//

import UIKit

import Moya

enum ReviewAPI {
    case createReview(request: CreateReviewRequest, images: [Data])
    case removeReview(id: Int)
    case getReviewsByStore(form: GetReviewByStoreRequest, lastReviewId: Int?, pageSize: Int)
    case getReviewsBySchool(form: CustomLocation, schoolId: Int, lastReviewId: Int?, pageSize: Int)
    case getReviewsByMember(form: CustomLocation, memberId: Int, lastReviewId: Int?, pageSize: Int)
    case getReviewsByFollowing(form: CustomLocation, lastReviewId: Int?, pageSize: Int)
    case getReviewsByBookmark(form: CustomLocation, lastReviewId: Int?, pageSize: Int)
}

extension ReviewAPI: TargetType {
    var baseURL: URL {
        @Configurations(key: ConfigurationsKey.baseURL, defaultValue: "")
        var baseURL: String
        return URL(string: baseURL)!
    }

    var path: String {
        switch self {
        case .createReview:
            return "/v1/reviews"
        case .removeReview(let id):
            return "/v1/reviews/\(id)"
        case .getReviewsByStore:
            return "/v1/reviews/stores"
        case .getReviewsBySchool:
            return "/v1/reviews/schools"
        case .getReviewsByMember:
            return "/v1/reviews/members"
        case .getReviewsByFollowing:
            return "/v1/reviews/following"
        case .getReviewsByBookmark:
            return "/v1/reviews/bookmarks"
        }
    }

    var method: Moya.Method {
        switch self {
        case .createReview:
            return .post
        case .removeReview:
            return .delete
        default:
            return .get
        }
    }

    var task: Task {
        switch self {
        case .createReview(let request, let images):
            var multipartFormData = [MultipartFormData]()

            if let reviewData = try? JSONEncoder().encode(request) {
                multipartFormData.append(
                    MultipartFormData(
                        provider: .data(reviewData),
                        name: "request",
                        mimeType: "application/json"
                    )
                )
            }

            for image in images {
                multipartFormData.append(
                    MultipartFormData(
                        provider: .data(image),
                        name: "images",
                        fileName: "\(request.storeName)_\(UUID().uuidString).jpg",
                        mimeType: "image/jpeg"
                    )
                )
            }

            return .uploadMultipart(multipartFormData)
        case .removeReview:
            return .requestPlain
        case .getReviewsByStore(let form, let lastReviewId, let pageSize):
            var params: [String: Any] = [
                "storeId": form.storeId,
                "filter": form.filter,
                "pageSize": pageSize
            ]

            if let lastReviewId = lastReviewId {
                params["lastReviewId"] = lastReviewId
            }

            return .requestParameters(
                parameters: params,
                encoding: URLEncoding.default
            )
        case .getReviewsBySchool(let form, let schoolId, let lastReviewId, let pageSize):
            var params: [String: Any] = [
                "schoolId": schoolId,
                "x": form.x,
                "y": form.y,
                "deltaX": form.deltaX,
                "deltaY": form.deltaY,
                "deviceX": form.deviceX,
                "deviceY": form.deviceY,
                "pageSize": pageSize
            ]

            if let lastReviewId = lastReviewId {
                params["lastReviewId"] = lastReviewId
            }

            return .requestParameters(
                parameters: params,
                encoding: URLEncoding.default
            )
        case .getReviewsByMember(let form, let memberId, let lastReviewId, let pageSize):
            var params: [String: Any] = [
                "memberId": memberId,
                "x": form.x,
                "y": form.y,
                "deltaX": form.deltaX,
                "deltaY": form.deltaY,
                "deviceX": form.deviceX,
                "deviceY": form.deviceY,
                "pageSize": pageSize
            ]

            if let lastReviewId = lastReviewId {
                params["lastReviewId"] = lastReviewId
            }

            return .requestParameters(
                parameters: params,
                encoding: URLEncoding.default
            )
        case .getReviewsByFollowing(let form, let lastReviewId, let pageSize):
            var params: [String: Any] = [
                "x": form.x,
                "y": form.y,
                "deltaX": form.deltaX,
                "deltaY": form.deltaY,
                "deviceX": form.deviceX,
                "deviceY": form.deviceY,
                "pageSize": pageSize
            ]

            if let lastReviewId = lastReviewId {
                params["lastReviewId"] = lastReviewId
            }

            return .requestParameters(
                parameters: params,
                encoding: URLEncoding.default
            )
        case .getReviewsByBookmark(let form, let lastReviewId, let pageSize):
            var params: [String: Any] = [
                "x": form.x,
                "y": form.y,
                "deltaX": form.deltaX,
                "deltaY": form.deltaY,
                "deviceX": form.deviceX,
                "deviceY": form.deviceY,
                "pageSize": pageSize
            ]

            if let lastReviewId = lastReviewId {
                params["lastReviewId"] = lastReviewId
            }

            return .requestParameters(
                parameters: params,
                encoding: URLEncoding.default
            )
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
