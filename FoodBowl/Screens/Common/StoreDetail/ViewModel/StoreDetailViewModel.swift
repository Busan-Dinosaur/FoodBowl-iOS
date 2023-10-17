//
//  StoreDetailViewModel.swift
//  FoodBowl
//
//  Created by COBY_PRO on 10/16/23.
//

import UIKit

import Moya

final class StoreDetailViewModel: BaseViewModel {}

// MARK: - Get Member's Reviews and Stores
extension StoreDetailViewModel {
    func getReviews(storeId: Int, filter: String) async -> [ReviewByStore] {
        let response = await providerReview.request(
            .getReviewsByStore(
                form: GetReviewByStoreRequest(storeId: storeId, filter: filter),
                lastReviewId: nil,
                pageSize: pageSize
            )
        )
        switch response {
        case .success(let result):
            guard let data = try? result.map(ReviewByStoreResponse.self) else { return [] }
            return data.storeReviewContentResponses
        case .failure(let err):
            handleError(err)
            return []
        }
    }
}
