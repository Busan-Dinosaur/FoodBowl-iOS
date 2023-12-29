//
//  MemberDTO.swift
//  FoodBowl
//
//  Created by COBY_PRO on 10/12/23.
//

import Foundation

// MARK: - MemberDTO
struct MemberDTO: Codable {
    let memberId: Int
    let nickname: String
    let profileImageUrl: String?
    let followerCount: Int
    let isFollowing, isMe: Bool
}

// MARK: - MemberBySearchDTO
struct MemberBySearchDTO: Codable {
    let memberSearchResponses: [MemberDTO]
}

// MARK: - MemberProfileDTO
struct MemberProfileDTO: Codable {
    let id: Int
    var profileImageUrl: String?
    var nickname: String
    var introduction: String?
    let followerCount: Int
    let followingCount: Int
    let isMyProfile: Bool
    let isFollowing: Bool
}

// MARK: - MemberByFollowDTO
struct MemberByFollowDTO: Codable {
    let content: [MemberByFollowItemDTO]
    let isFirst, isLast, hasNext: Bool
    let currentPage, currentSize: Int
}

// MARK: - MemberByFollowItemDTO
struct MemberByFollowItemDTO: Codable, Hashable {
    let memberId: Int
    let profileImageUrl: String?
    let nickname: String
    let followerCount: Int
    var isFollowing: Bool
}
