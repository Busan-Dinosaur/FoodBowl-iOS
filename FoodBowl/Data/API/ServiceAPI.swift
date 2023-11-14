//
//  ServiceAPI.swift
//  FoodBowl
//
//  Created by COBY_PRO on 10/12/23.
//

import Foundation

import Moya

enum ServiceAPI {
    case signIn(request: SignRequestDTO)
    case logOut
    case renew
    case checkNickname(nickname: String)
    case getSchools
    case getCategories
    case createBlame(request: CreateBlameRequest)
    case createReview(request: CreateReviewRequest, images: [Data])
    case removeReview(id: Int)
    case getReviewsByStore(form: GetReviewByStoreRequest, lastReviewId: Int?, pageSize: Int)
    case getReviewsBySchool(form: CustomLocation, schoolId: Int, lastReviewId: Int?, pageSize: Int)
    case getReviewsByMember(form: CustomLocation, memberId: Int, lastReviewId: Int?, pageSize: Int)
    case getReviewsByFollowing(form: CustomLocation, lastReviewId: Int?, pageSize: Int)
    case getReviewsByBookmark(form: CustomLocation, lastReviewId: Int?, pageSize: Int)
    case getStoresBySearch(form: SearchStoresRequest)
    case getStoresBySchool(form: CustomLocation, schoolId: Int)
    case getStoresByMember(form: CustomLocation, memberId: Int)
    case getStoresByFollowing(form: CustomLocation)
    case getStoresByBookmark(form: CustomLocation)
    case createBookmark(storeId: Int)
    case removeBookmark(storeId: Int)
    case updateMemberProfile(request: UpdateMemberProfileRequest)
    case removeMemberProfileImage
    case updateMemberProfileImage(image: Data)
    case getMemberProfile(id: Int)
    case getMemberBySearch(form: SearchMembersRequest)
    case getMyProfile
    case followMember(memberId: Int)
    case unfollowMember(memberId: Int)
    case removeFollower(memberId: Int)
    case getFollowingMember(memberId: Int, page: Int, size: Int)
    case getFollowerMember(memberId: Int, page: Int, size: Int)
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
        case .logOut:
            return "/v1/auth/logout"
        case .renew:
            return "/v1/auth/token/renew"
        case .checkNickname:
            return "/v1/members/nickname/exist"
        case .getSchools:
            return "/v1/schools"
        case .getCategories:
            return "/v1/stores/categories"
        case .createBlame:
            return "/v1/blames"
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
        case .createBookmark, .removeBookmark:
            return "/v1/bookmarks"
        case .updateMemberProfile:
            return "/v1/members/profile"
        case .removeMemberProfileImage, .updateMemberProfileImage:
            return "/v1/members/profile/image"
        case .getMemberProfile(let id):
            return "/v1/members/\(id)/profile"
        case .getMemberBySearch:
            return "/v1/members/search"
        case .getMyProfile:
            return "/v1/members/me/profile"
        case .followMember(let memberId):
            return "/v1/follows/\(memberId)/follow"
        case .unfollowMember(let memberId):
            return "/v1/follows/\(memberId)/unfollow"
        case .removeFollower(let memberId):
            return "/v1/follows/followers/\(memberId)"
        case .getFollowingMember(let memberId, _, _):
            return "/v1/follows/\(memberId)/followings"
        case .getFollowerMember(let memberId, _, _):
            return "/v1/follows/\(memberId)/followers"
        }
    }

    var method: Moya.Method {
        switch self {
        case .signIn, .logOut, .renew, .createBlame, .createReview, .createBookmark, .followMember:
            return .post
        case .updateMemberProfile, .updateMemberProfileImage:
            return .patch
        case .removeReview, .removeBookmark, .removeMemberProfileImage, .unfollowMember, .removeFollower:
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
            let request = RenewRequest(
                accessToken: KeychainManager.get(.accessToken),
                refreshToken: KeychainManager.get(.refreshToken)
            )
            return .requestJSONEncodable(request)
        case .checkNickname(let nickname):
            let params: [String: String] = [
                "nickname": nickname
            ]
            return .requestParameters(
                parameters: params,
                encoding: URLEncoding.default
            )
        case .createBlame(let request):
            return .requestJSONEncodable(request)
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
        case .getStoresBySearch(let form):
            let params: [String: Any] = [
                "name": form.name,
                "x": form.x,
                "y": form.y,
                "size": form.size
            ]
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
        case .createBookmark(let storeId):
            let params: [String: Int] = [
                "storeId": storeId
            ]
            return .requestParameters(
                parameters: params,
                encoding: URLEncoding(destination: .queryString)
            )
        case .removeBookmark(let storeId):
            let params: [String: Int] = [
                "storeId": storeId
            ]
            return .requestParameters(
                parameters: params,
                encoding: URLEncoding.default
            )
        case .updateMemberProfile(let request):
            return .requestJSONEncodable(request)
        case .updateMemberProfileImage(let image):
            let id = String(describing: UserDefaultsManager.currentUser?.id)
            let imageData = MultipartFormData(
                provider: .data(image),
                name: "image",
                fileName: "\(id).jpg",
                mimeType: "image/jpeg"
            )
            return .uploadMultipart([imageData])
        case .getMemberBySearch(let form):
            let params: [String: Any] = [
                "name": form.name,
                "size": form.size
            ]
            return .requestParameters(
                parameters: params,
                encoding: URLEncoding.default
            )
        case .getFollowingMember(_, let page, let size):
            let params: [String: Int] = [
                "page": page,
                "size": size
            ]
            return .requestParameters(
                parameters: params,
                encoding: URLEncoding.default
            )
        case .getFollowerMember(_, let page, let size):
            let params: [String: Int] = [
                "page": page,
                "size": size
            ]
            return .requestParameters(
                parameters: params,
                encoding: URLEncoding.default
            )
        default:
            return .requestPlain
        }
    }

    var headers: [String: String]? {
        let accessToken: String = KeychainManager.get(.accessToken)
        
        switch self {
        case .signIn, .renew:
            return [
                "Content-Type": "application/json"
            ]
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
