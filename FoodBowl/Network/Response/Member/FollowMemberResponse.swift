//
//  FollowMemberResponse.swift
//  FoodBowl
//
//  Created by COBY_PRO on 10/16/23.
//

import Foundation

// MARK: - FollowMemberResponse
struct FollowMemberResponse: Codable {
    let content: [MemberByFollow]
    let isFirst, isLast, hasNext: Bool
    let currentPage, currentSize: Int
}

// MARK: - Content
struct MemberByFollow: Codable {
    let memberId: Int
    let profileImageUrl: String?
    let nickname: String
    let followerCount: Int
    var isFollowing: Bool
}
