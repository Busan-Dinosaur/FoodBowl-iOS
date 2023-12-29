//
//  MemberRepository.swift
//  FoodBowl
//
//  Created by Coby on 12/30/23.
//

import Foundation

protocol MemberRepository {
    func updateMemberProfile(request: UpdateMemberProfileRequestDTO) async throws
    func removeMemberProfileImage() async throws
    func updateMemberProfileImage(image: Data) async throws
    func getMemberProfile(id: Int) async throws -> MemberProfileDTO
    func getMemberBySearch(request: SearchMemberRequestDTO) async throws -> MemberBySearchDTO
    func followMember(memberId: Int) async throws
    func unfollowMember(memberId: Int) async throws
    func removeFollower(memberId: Int) async throws
    func getFollowingMember(memberId: Int, page: Int, size: Int) async throws -> MemberByFollowDTO
    func getFollowerMember(memberId: Int, page: Int, size: Int) async throws -> MemberByFollowDTO
}
