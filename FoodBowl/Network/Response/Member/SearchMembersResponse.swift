//
//  SearchMembersResponse.swift
//  FoodBowl
//
//  Created by COBY_PRO on 10/12/23.
//

import Foundation

// MARK: - SearchMembersResponse
struct SearchMembersResponse: Codable {
    let memberSearchResponses: [MemberBySearch]
}

// MARK: - MemberSearchResponse
struct MemberBySearch: Codable {
    let memberId: Int
    let nickname: String
    let profileImageUrl: String?
    let followerCount: Int
    let isFollowing, isMe: Bool
}
