//
//  MemberRepositoryImpl.swift
//  FoodBowl
//
//  Created by Coby on 12/30/23.
//

import Foundation

import Moya

final class MemberRepositoryImpl: MemberRepository {
    
    private let provider = MoyaProvider<ServiceAPI>()
    
    func updateMemberProfile(request: UpdateMemberProfileRequestDTO) async throws {
        let _ = await provider.request(.updateMemberProfile(request: request))
    }
    
    func removeMemberProfileImage() async throws {
        let _ = await provider.request(.removeMemberProfileImage)
    }
    
    func updateMemberProfileImage(image: Data) async throws {
        let _ = await provider.request(.updateMemberProfileImage(image: image))
    }
    
    func getMemberProfile(id: Int) async throws -> MemberProfileDTO {
        let response = await provider.request(.getMemberProfile(id: id))
        return try response.decode()
    }
    
    func getMemberBySearch(request: SearchMemberRequestDTO) async throws -> MemberBySearchDTO {
        let response = await provider.request(.getMemberBySearch(request: request))
        return try response.decode()
    }
    
    func followMember(memberId: Int) async throws {
        let _ = await provider.request(.followMember(memberId: memberId))
    }
    
    func unfollowMember(memberId: Int) async throws {
        let _ = await provider.request(.unfollowMember(memberId: memberId))
    }
    
    func removeFollower(memberId: Int) async throws {
        let _ = await provider.request(.removeFollower(memberId: memberId))
    }
    
    func getFollowingMember(memberId: Int, page: Int, size: Int) async throws -> MemberByFollowDTO {
        let response = await provider.request(.getFollowingMember(memberId: memberId, page: page, size: size))
        return try response.decode()
    }
    
    func getFollowerMember(memberId: Int, page: Int, size: Int) async throws -> MemberByFollowDTO {
        let response = await provider.request(.getFollowerMember(memberId: memberId, page: page, size: size))
        return try response.decode()
    }
}
