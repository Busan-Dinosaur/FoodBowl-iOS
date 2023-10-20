//
//  StoreDetailViewModel.swift
//  FoodBowl
//
//  Created by COBY_PRO on 10/16/23.
//

import Combine
import UIKit

import CombineMoya
import Moya

final class StoreDetailViewModel: NSObject, BaseViewModelType {
    
    // MARK: - property

    let providerReview = MoyaProvider<ReviewAPI>()
    let providerFollow = MoyaProvider<FollowAPI>()
    
    private var cancellable = Set<AnyCancellable>()
    
    private let pageSize: Int = 10
    private let size: Int = 15
    var storeId: Int
    var isFriend: Bool
    private var lastReviewId: Int?
    private var currentpageSize: Int?
    
    struct Input {
        let viewDidLoad: AnyPublisher<Void, Never>
    }
    
    struct Output {
        let reviews: AnyPublisher<[ReviewByStore], Error>
    }
    
    // MARK: - init

    init(storeId: Int, isFriend: Bool) {
        self.storeId = storeId
        self.isFriend = isFriend
    }
    
    // MARK: - Public - func
    
    func transform(from input: Input) -> Output {
        return Output(
            reviews: getReviewsPublisher()
        )
    }
    
    // MARK: - network
    
    private func getReviewsPublisher() -> AnyPublisher<[ReviewByStore], Error> {
        let filter = isFriend ? "FRIEND" : "ALL"
        return providerReview.requestPublisher(
            .getReviewsByStore(
                form: GetReviewByStoreRequest(storeId: storeId, filter: filter),
                lastReviewId: lastReviewId,
                pageSize: pageSize
            )
        )
        .tryMap { result in
            try result.map(ReviewByStoreResponse.self).storeReviewContentResponses
        }
        .eraseToAnyPublisher()
    }
}
