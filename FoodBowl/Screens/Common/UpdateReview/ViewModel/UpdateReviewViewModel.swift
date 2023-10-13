//
//  UpdateReviewViewModel.swift
//  FoodBowl
//
//  Created by COBY_PRO on 2023/09/12.
//

import UIKit

import Moya

final class UpdateReviewViewModel {
    var request = CreateReviewRequest()
    var images = [UIImage]()

    private let providerKakao = MoyaProvider<KakaoAPI>()
    private let providerStore = MoyaProvider<StoreAPI>()

    func updateReview() async {}
}
