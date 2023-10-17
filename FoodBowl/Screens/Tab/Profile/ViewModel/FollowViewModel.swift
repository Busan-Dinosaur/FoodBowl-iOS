//
//  FollowViewModel.swift
//  FoodBowl
//
//  Created by COBY_PRO on 10/16/23.
//

final class FollowViewModel: BaseViewModel {}

// MARK: - Member Method
extension FollowViewModel {
    func getFollowerMembers(memberId: Int, page: Int = 0) async -> [MemberByFollow] {
        let response = await providerFollow.request(
            .getFollowerMember(
                memberId: memberId,
                page: page,
                size: size
            )
        )
        switch response {
        case .success(let result):
            guard let data = try? result.map(FollowMemberResponse.self) else { return [] }
            return data.content
        case .failure(let err):
            handleError(err)
            return []
        }
    }

    func getFollowingMembers(memberId: Int, page: Int = 0) async -> [MemberByFollow] {
        let response = await providerFollow.request(
            .getFollowingMember(
                memberId: memberId,
                page: page,
                size: size
            )
        )
        switch response {
        case .success(let result):
            guard let data = try? result.map(FollowMemberResponse.self) else { return [] }
            return data.content
        case .failure(let err):
            handleError(err)
            return []
        }
    }

    func removeFollowingMember(memberId: Int) async -> Bool {
        let response = await providerFollow.request(.removeFollower(memberId: memberId))
        switch response {
        case .success:
            return true
        case .failure(let err):
            handleError(err)
            return false
        }
    }
}
