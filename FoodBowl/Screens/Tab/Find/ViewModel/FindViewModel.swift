//
//  FindViewModel.swift
//  FoodBowl
//
//  Created by COBY_PRO on 10/12/23.
//

import UIKit

import Moya

final class FindViewModel: BaseViewModel {}

// MARK: - Get Stores and Members
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

    func searchMembers(name: String) async -> [Member] {
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
