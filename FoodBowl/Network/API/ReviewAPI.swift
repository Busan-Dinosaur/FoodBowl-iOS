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
    case getReviewsBySchool(form: GetReviewsRequest, schoolId: Int)
    case getReviewsByMember(form: GetReviewsRequest, memberId: Int)
    case getReviewsByFollowing(form: GetReviewsRequest)
    case getReviewsByBookmark(form: GetReviewsRequest)
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
                        name: "form",
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
        case .getReviewsBySchool(let form, let schoolId):
            let params: [String: Any?] = [
                "schoolId": schoolId,
                "lastReviewId": form.lastReviewId,
                "x": form.x,
                "y": form.y,
                "deltaX": form.deltaX,
                "deltaY": form.deltaY,
                "deviceX": form.deviceX,
                "deviceY": form.deviceY,
                "pageSize": form.pageSize
            ]
            return .requestParameters(
                parameters: params as [String: Any],
                encoding: URLEncoding.default
            )
        case .getReviewsByMember(let form, let memberId):
            let params: [String: Any?] = [
                "memberId": memberId,
                "lastReviewId": form.lastReviewId,
                "x": form.x,
                "y": form.y,
                "deltaX": form.deltaX,
                "deltaY": form.deltaY,
                "deviceX": form.deviceX,
                "deviceY": form.deviceY,
                "pageSize": form.pageSize
            ]
            return .requestParameters(
                parameters: params as [String: Any],
                encoding: URLEncoding.default
            )
        case .getReviewsByFollowing(let form):
            let params: [String: Any?] = [
                "lastReviewId": form.lastReviewId,
                "x": form.x,
                "y": form.y,
                "deltaX": form.deltaX,
                "deltaY": form.deltaY,
                "deviceX": form.deviceX,
                "deviceY": form.deviceY,
                "pageSize": form.pageSize
            ]
            return .requestParameters(
                parameters: params as [String: Any],
                encoding: URLEncoding.default
            )
        case .getReviewsByBookmark(let form):
            let params: [String: Any?] = [
                "lastReviewId": form.lastReviewId,
                "x": form.x,
                "y": form.y,
                "deltaX": form.deltaX,
                "deltaY": form.deltaY,
                "deviceX": form.deviceX,
                "deviceY": form.deviceY,
                "pageSize": form.pageSize
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
