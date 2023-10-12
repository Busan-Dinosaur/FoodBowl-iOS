//
//  MemberAPI.swift
//  FoodBowl
//
//  Created by COBY_PRO on 2023/08/09.
//

import Foundation

import Moya

enum MemberAPI {
    case updateProfile(form: UpdateProfileRequest)
    case getMyProfile
    case getMemberProfile(id: Int)
    case followMember(memberId: Int)
    case unfollowMember(memberId: Int)
    case removeFollower(memberId: Int)
    case getFollowingMember(memberId: Int)
    case getFollowerMember(memberId: Int)
}

extension MemberAPI: TargetType {
    var baseURL: URL {
        @Configurations(key: ConfigurationsKey.baseURL, defaultValue: "")
        var baseURL: String
        return URL(string: baseURL)!
    }

    var path: String {
        switch self {
        case .updateProfile:
            return "/v1/members/profile"
        case .getMyProfile:
            return "/v1/members/me/profile"
        case .getMemberProfile(let id):
            return "/v1/members/\(id)/profile"
        case .followMember(let memberId):
            return "/v1/follows/\(memberId)/follow"
        case .unfollowMember(let memberId):
            return "/v1/follows/\(memberId)/unfollow"
        case .removeFollower(let memberId):
            return "/v1/follows/followers/\(memberId)"
        case .getFollowingMember(let memberId):
            return "/v1/follows/\(memberId)/followings"
        case .getFollowerMember(let memberId):
            return "/v1/follows/\(memberId)/followers"
        }
    }

    var method: Moya.Method {
        switch self {
        case .followMember:
            return .post
        case .updateProfile:
            return .patch
        case .unfollowMember, .removeFollower:
            return .delete
        default:
            return .get
        }
    }

    var task: Task {
        switch self {
        case .updateProfile(let form):
            return .requestJSONEncodable(form)
        default:
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
