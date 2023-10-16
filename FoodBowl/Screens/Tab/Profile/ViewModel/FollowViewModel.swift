//
//  FollowViewModel.swift
//  FoodBowl
//
//  Created by COBY_PRO on 10/16/23.
//

final class FollowViewModel: BaseViewModel {}

// MARK: - Member Method
extension FollowViewModel {
    func getFollowerMembers(memberId: Int, page: Int) async -> [MemberByFollow] {
        let response = await providerFollow.request(
            .getFollowerMember(
                memberId: memberId,
                page: 0,
                size: size
            )
        )
        switch response {
        case .success(let result):
            guard let data = try? result.map(FollowMemberResponse.self) else { return [] }
            return data.content
        case .failure(let err):
            print(err.localizedDescription)
            return []
        }
    }
    
    func getFollowingMembers(memberId: Int, page: Int) async -> [MemberByFollow] {
        let response = await providerFollow.request(
            .getFollowerMember(
                memberId: memberId,
                page: 0,
                size: size
            )
        )
        switch response {
        case .success(let result):
            guard let data = try? result.map(FollowMemberResponse.self) else { return [] }
            return data.content
        case .failure(let err):
            print(err.localizedDescription)
            return []
        }
    }
    
    func removeFollowingMember(memberId: Int) async -> Bool {
        let response = await providerFollow.request(.removeFollower(memberId: memberId))
        switch response {
        case .success:
            print("Remove Following Member")
            return true
        case .failure(let err):
            print(err.localizedDescription)
            return false
        }
    }
}
