//
//  BaseViewModel.swift
//  FoodBowl
//
//  Created by COBY_PRO on 10/16/23.
//

import UIKit

import Moya

class BaseViewModel {
    let pageSize = 10
    let size = 10

    let providerService = MoyaProvider<ServiceAPI>()
    let providerReview = MoyaProvider<ReviewAPI>()
    let providerStore = MoyaProvider<StoreAPI>()
    let providerMember = MoyaProvider<MemberAPI>()
    let providerFollow = MoyaProvider<FollowAPI>()
}

// MARK: - Reviews Method
extension BaseViewModel {
    func removeReview(id: Int) async -> Bool {
        let response = await providerReview.request(.removeReview(id: id))
        switch response {
        case .success:
            print("Remove Review")
            return true
        case .failure(let err):
            print(err.localizedDescription)
            return false
        }
    }
}

// MARK: - Follow Method
extension BaseViewModel {
    func followMember(memberId: Int) async -> Bool {
        let response = await providerFollow.request(.followMember(memberId: memberId))
        switch response {
        case .success:
            print("Success to Follow")
            return true
        case .failure(let err):
            print(err.localizedDescription)
            return false
        }
    }

    func unfollowMember(memberId: Int) async -> Bool {
        let response = await providerFollow.request(.unfollowMember(memberId: memberId))
        switch response {
        case .success:
            print("Success to Unfollow")
            return false
        case .failure(let err):
            print(err.localizedDescription)
            return true
        }
    }
}
