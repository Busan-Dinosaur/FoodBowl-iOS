//
//  FindViewModel.swift
//  FoodBowl
//
//  Created by COBY_PRO on 10/12/23.
//

import UIKit

import Moya

final class FindViewModel {
    private let providerService = MoyaProvider<ServiceAPI>()
    private let providerReview = MoyaProvider<ReviewAPI>()
    private let providerStore = MoyaProvider<StoreAPI>()
    private let providerFollow = MoyaProvider<FollowAPI>()
}
