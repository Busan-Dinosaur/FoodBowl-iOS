//
//  UnivViewModel.swift
//  FoodBowl
//
//  Created by COBY_PRO on 2023/09/18.
//

import UIKit

import Moya

final class UnivViewModel: BaseViewModel {}

// MARK: - Get Univs
extension UnivViewModel {
    func getSchools() async -> [School] {
        let response = await providerService.request(.getSchools)
        switch response {
        case .success(let result):
            guard let data = try? result.map(SchoolResponse.self) else { return [School]() }
            return data.schools
        case .failure(let err):
            handleError(err)
            return [School]()
        }
    }
}

// MARK: - Get Univ's Reviews and Stores
extension UnivViewModel {
    func getReviews(location: CustomLocation, lastReviewId: Int? = nil) async -> [Review] {
        guard let schoolId = UserDefaultsManager.currentUniv?.id else { return [] }
        let response = await providerReview.request(
            .getReviewsBySchool(
                form: location,
                schoolId: schoolId,
                lastReviewId: lastReviewId,
                pageSize: pageSize
            )
        )
        switch response {
        case .success(let result):
            guard let data = try? result.map(ReviewResponse.self) else { return [] }
            self.lastReviewId = data.page.lastId
            currentpageSize = data.page.size
            return data.reviews
        case .failure(let err):
            handleError(err)
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
            handleError(err)
            return [Store]()
        }
    }
}
