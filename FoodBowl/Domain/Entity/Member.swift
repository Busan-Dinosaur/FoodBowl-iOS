//
//  Member.swift
//  FoodBowl
//
//  Created by Coby on 1/19/24.
//

import Foundation

// MARK: - Member
struct Member: Codable {
    let id: Int
    let profileImageUrl: String?
    let nickname: String
    let introduction: String
    let followerCount: String
    let followingCount: String
    let isMyProfile: Bool
    var isFollowing: Bool
}
