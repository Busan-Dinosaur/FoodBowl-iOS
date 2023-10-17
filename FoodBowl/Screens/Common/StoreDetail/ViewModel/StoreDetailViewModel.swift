//
//  StoreDetailViewModel.swift
//  FoodBowl
//
//  Created by COBY_PRO on 10/16/23.
//

import UIKit

import Moya

final class StoreDetailViewModel {
    private let pageSize = 10

    private let providerService = MoyaProvider<ServiceAPI>()
    private let providerReview = MoyaProvider<ReviewAPI>()
    private let providerStore = MoyaProvider<StoreAPI>()
    private let providerMember = MoyaProvider<MemberAPI>()
    private let providerFollow = MoyaProvider<FollowAPI>()
}

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

    func handleError(_ error: MoyaError) {
        if let errorResponse = error.errorResponse {
            print("에러 코드: \(errorResponse.errorCode)")
            print("에러 메시지: \(errorResponse.message)")
        } else {
            print("네트워크 에러: \(error.localizedDescription)")
        }
    }
}
