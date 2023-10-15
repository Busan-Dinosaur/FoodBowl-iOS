//
//  UnivViewModel.swift
//  FoodBowl
//
//  Created by COBY_PRO on 2023/09/18.
//

import UIKit

import Moya

final class UnivViewModel {
    private let providerService = MoyaProvider<ServiceAPI>()
    private let providerReview = MoyaProvider<ReviewAPI>()
    private let providerStore = MoyaProvider<StoreAPI>()
}

// MARK: - Get Univs
extension UnivViewModel {
    func getSchools() async -> [School] {
        let response = await providerService.request(.getSchools)
        switch response {
        case .success(let result):
            guard let data = try? result.map(SchoolResponse.self) else { return [School]() }
            return data.schools
        case .failure(let err):
            print(err.localizedDescription)
            return [School]()
        }
    }
}

// MARK: - Get Univ's Reviews and Stores
extension UnivViewModel {
    func getReviews(location: CustomLocation) async -> [Review] {
        guard let schoolId = UserDefaultsManager.currentUniv?.id else { return [] }
        let response = await providerReview.request(
            .getReviewsBySchool(
                form: location,
                schoolId: schoolId,
                lastReviewId: nil,
                pageSize: nil
            )
        )
        switch response {
        case .success(let result):
            guard let data = try? result.map(ReviewResponse.self) else { return [] }
            return data.reviews
        case .failure(let err):
            print(err.localizedDescription)
            return []
        }
    }

    func getStores(location: CustomLocation) async -> [Store] {
        guard let schoolId = UserDefaultsManager.currentUniv?.id else { return [] }
        let response = await providerStore.request(.getStoresBySchool(form: location, schoolId: schoolId))
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
