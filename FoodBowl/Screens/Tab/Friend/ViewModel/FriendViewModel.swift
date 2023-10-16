//
//  FriendViewModel.swift
//  FoodBowl
//
//  Created by COBY_PRO on 10/12/23.
//

import UIKit

import Moya

final class FriendViewModel: BaseViewModel {}

// MARK: - Get Friends's Reviews and Stores
extension FriendViewModel {
    func getReviews(location: CustomLocation) async -> [Review] {
        let response = await providerReview.request(
            .getReviewsByFollowing(
                form: location,
                lastReviewId: nil,
                pageSize: pageSize
            )
        )
        switch response {
        case .success(let result):
            guard let data = try? result.map(ReviewResponse.self) else { return [Review]() }
            return data.reviews
        case .failure(let err):
            print(err.localizedDescription)
            return [Review]()
        }
    }

    func getStores(location: CustomLocation) async -> [Store] {
        let response = await providerStore.request(.getStoresByFollowing(form: location))
        switch response {
        case .success(let result):
            guard let data = try? result.map(StoreResponse.self) else { return [Store]() }
            return data.stores
        case .failure(let err):
            print(err.localizedDescription)
            return [Store]()
        }
    }
}
