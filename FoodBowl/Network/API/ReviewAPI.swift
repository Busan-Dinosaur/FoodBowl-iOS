//
//  ReviewAPI.swift
//  FoodBowl
//
//  Created by COBY_PRO on 10/12/23.
//

import UIKit

import Moya

enum ReviewAPI {
    case createReview(request: CreateReviewRequest)
    case removeReview(id: Int)
    case getReviewsBySchool(request: GetReviewsRequest, schoolId: Int)
    case getReviewsByMember(request: GetReviewsRequest, memberId: Int)
    case getReviewsByFollowing(request: GetReviewsRequest)
    case getReviewsByBookmark(request: GetReviewsRequest)
}

extension ReviewAPI: TargetType {
    var baseURL: URL {
        @Configurations(key: ConfigurationsKey.baseURL, defaultValue: "")
        var baseURL: String
        return URL(string: baseURL)!
    }

    var path: String {
        switch self {
        case .createReview, .removeReview:
            return "/v1/reviews"
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
        case .getReviewsBySchool(let request, let schoolId):
            let params: [String: Any?] = [
                "schoolId": schoolId,
                "lastReviewId": request.lastReviewId,
                "x": request.x,
                "y": request.y,
                "deltaX": request.deltaX,
                "deltaY": request.deltaY,
                "deviceX": request.deviceX,
                "deviceY": request.deviceY,
                "pageSize": request.pageSize
            ]
            return .requestParameters(
                parameters: params as [String: Any],
                encoding: URLEncoding.default
            )
        case .getReviewsByMember(let request, let memberId):
            let params: [String: Any?] = [
                "memberId": memberId,
                "lastReviewId": request.lastReviewId,
                "x": request.x,
                "y": request.y,
                "deltaX": request.deltaX,
                "deltaY": request.deltaY,
                "deviceX": request.deviceX,
                "deviceY": request.deviceY,
                "pageSize": request.pageSize
            ]
            return .requestParameters(
                parameters: params as [String: Any],
                encoding: URLEncoding.default
            )
        case .getReviewsByFollowing(let request):
            let params: [String: Any?] = [
                "lastReviewId": request.lastReviewId,
                "x": request.x,
                "y": request.y,
                "deltaX": request.deltaX,
                "deltaY": request.deltaY,
                "deviceX": request.deviceX,
                "deviceY": request.deviceY,
                "pageSize": request.pageSize
            ]
            return .requestParameters(
                parameters: params as [String: Any],
                encoding: URLEncoding.default
            )
        case .getReviewsByBookmark(let request):
            let params: [String: Any?] = [
                "lastReviewId": request.lastReviewId,
                "x": request.x,
                "y": request.y,
                "deltaX": request.deltaX,
                "deltaY": request.deltaY,
                "deviceX": request.deviceX,
                "deviceY": request.deviceY,
                "pageSize": request.pageSize
            ]
            return .requestParameters(
                parameters: params as [String: Any],
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
