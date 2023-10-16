//
//  FindViewModel.swift
//  FoodBowl
//
//  Created by COBY_PRO on 10/12/23.
//

import UIKit

import Moya

final class FindViewModel {
    private let size = 10

    private let providerService = MoyaProvider<ServiceAPI>()
    private let providerReview = MoyaProvider<ReviewAPI>()
    private let providerStore = MoyaProvider<StoreAPI>()
    private let providerMember = MoyaProvider<MemberAPI>()
    private let providerFollow = MoyaProvider<FollowAPI>()
}

// MARK: - Get Stores and Users
extension FindViewModel {
    func serachStores(name: String) async -> [StoreBySearch] {
        guard let currentLoc = LocationManager.shared.manager.location?.coordinate else { return [] }
        let response = await providerStore.request(
            .getStoresBySearch(
                form: SearchStoresRequest(
                    name: name,
                    x: currentLoc.longitude,
                    y: currentLoc.latitude,
                    size: size
                )
            )
        )
        switch response {
        case .success(let result):
            guard let data = try? result.map(SearchStoresResponse.self) else { return [] }
            return data.searchResponses
        case .failure(let err):
            print(err.localizedDescription)
            return []
        }
    }

    func searchMembers(name: String) async -> [MemberBySearch] {
        let response = await providerMember.request(
            .getMemberBySearch(
                form: SearchMembersRequest(
                    name: name,
                    size: size
                )
            )
        )
        switch response {
        case .success(let result):
            guard let data = try? result.map(SearchMembersResponse.self) else { return [] }
            return data.memberSearchResponses
        case .failure(let err):
            print(err.localizedDescription)
            return []
        }
    }
}

// MARK: - Follow Method
extension FindViewModel {
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
