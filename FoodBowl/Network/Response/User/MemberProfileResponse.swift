//
//  MemberProfileResponse.swift
//  FoodBowl
//
//  Created by COBY_PRO on 2023/09/05.
//

import Foundation

struct MemberProfileResponse: Decodable {
    let id: Int
    let profileImageUrl: String?
    let nickname: String
    let introduction: String?
    let followerCount: Int
    let followingCount: Int
    let isMyProfile: Bool
    let isFollowing: Bool
}
