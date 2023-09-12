//
//  UserAPI.swift
//  FoodBowl
//
//  Created by COBY_PRO on 2023/08/09.
//

import Foundation

import Moya

enum UserAPI {
    case signIn(form: SignRequest)
    case renew
    case updateProfile(form: UpdateProfileRequest)
    case getMyProfile
    case getMemberProfile(id: Int)
    case checkNickname(nickname: String)
    case followUser(memberId: Int)
    case unfollowUser(memberId: Int)
    case removeFollower(memberId: Int)
    case getFollowingUser(memberId: Int)
    case getFollowerUser(memberId: Int)
}

extension UserAPI: TargetType {
    var baseURL: URL {
        @Configurations(key: ConfigurationsKey.baseURL, defaultValue: "")
        var baseURL: String
        return URL(string: baseURL)!
    }

    var path: String {
        switch self {
        case .signIn:
            return "/v1/auth/login/oauth/apple"
        case .renew:
            return "/v1/auth/token/renew"
        case .updateProfile:
            return "/v1/members/profile"
        case .getMyProfile:
            return "/v1/members/me/profile"
        case .getMemberProfile(let id):
            return "/v1/members/\(id)/profile"
        case .checkNickname:
            return "/v1/members/nickname/exist"
        case .followUser(let memberId):
            return "/v1/follows/\(memberId)/follow"
        case .unfollowUser(let memberId):
            return "/v1/follows/\(memberId)/unfollow"
        case .removeFollower(let memberId):
            return "/v1/follows/followers/\(memberId)"
        case .getFollowingUser(let memberId):
            return "/v1/follows/\(memberId)/followings"
        case .getFollowerUser(let memberId):
            return "/v1/follows/\(memberId)/followers"
        }
    }

    var method: Moya.Method {
        switch self {
        case .signIn, .renew, .followUser:
            return .post
        case .updateProfile:
            return .patch
        case .unfollowUser, .removeFollower:
            return .delete
        default:
            return .get
        }
    }

    var task: Task {
        switch self {
        case .signIn(let form):
            return .requestJSONEncodable(form)
        case .renew:
            let form = RenewRequest(
                accessToken: KeychainManager.get(.accessToken),
                refreshToken: KeychainManager.get(.refreshToken)
            )
            return .requestJSONEncodable(form)
        case .updateProfile(let form):
            return .requestJSONEncodable(form)
        case .checkNickname(let nickname):
            let params: [String: String] = [
                "nickname": nickname
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
        switch self {
        case .signIn:
            return [
                "Content-Type": "application/json"
            ]
        default:
            let accessToken: String = KeychainManager.get(.accessToken)

            return [
                "Content-Type": "application/json",
                "Authorization": "Bearer " + accessToken
            ]
        }
    }

    var validationType: ValidationType { .successCodes }
}
