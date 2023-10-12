//
//  MemberProfileResponse.swift
//  FoodBowl
//
//  Created by COBY_PRO on 2023/09/05.
//

import Foundation

struct MemberProfileResponse: Codable {
    let id: Int
    var profileImageUrl: String?
    var nickname: String
    var introduction: String?
    let followerCount: Int
    let followingCount: Int
    let isMyProfile: Bool
    let isFollowing: Bool
}
