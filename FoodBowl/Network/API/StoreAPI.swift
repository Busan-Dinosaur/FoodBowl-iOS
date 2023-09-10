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
    case createReview(review: ReviewCreateRequest, images: [UIImage])
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
        case .createReview(let review, let images):
            var multipartFormData = [MultipartFormData]()
            let params: [String: String] = [
                "locationId": review.locationId,
                "storeName": review.storeName,
                "storeAddress": review.storeAddress,
                "x": String(review.x),
                "y": String(review.y),
                "storeUrl": review.storeUrl,
                "phone": review.phone,
                "category": review.category,
                "reviewContent": review.reviewContent,
                "schoolName": review.schoolName,
                "schoolX": String(review.schoolX),
                "schoolY": String(review.schoolY)
            ]

            for (key, value) in params {
                multipartFormData.append(MultipartFormData(provider: .data(value.data(using: String.Encoding.utf8)!), name: key))
            }

            let imagesData = images.map { $0.jpegData(compressionQuality: 1.0) }

            for imageData in imagesData {
                multipartFormData.append(
                    MultipartFormData(
                        provider: .data(imageData!),
                        name: "images",
                        fileName: "photo.jpg",
                        mimeType: "image/jpeg"
                    )
                )
            }

            print(multipartFormData)

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
                "Content-Type": "multipart/form-data",
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
