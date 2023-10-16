//
//  MemberAPI.swift
//  FoodBowl
//
//  Created by COBY_PRO on 2023/08/09.
//

import Foundation

import Moya

enum MemberAPI {
    case updateMemberProfile(request: UpdateMemberProfileRequest)
    case removeMemberProfileImage
    case updateMemberProfileImage(image: Data)
    case getMemberProfile(id: Int)
    case getMemberBySearch(form: SearchMembersRequest)
    case getMyProfile
}

extension MemberAPI: TargetType {
    var baseURL: URL {
        @Configurations(key: ConfigurationsKey.baseURL, defaultValue: "")
        var baseURL: String
        return URL(string: baseURL)!
    }

    var path: String {
        switch self {
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
        }
    }

    var method: Moya.Method {
        switch self {
        case .updateMemberProfile, .updateMemberProfileImage:
            return .patch
        case .removeMemberProfileImage:
            return .delete
        default:
            return .get
        }
    }

    var task: Task {
        switch self {
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
