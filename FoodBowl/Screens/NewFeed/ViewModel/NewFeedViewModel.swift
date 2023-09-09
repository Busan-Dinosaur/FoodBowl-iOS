//
//  NewFeedViewModel.swift
//  FoodBowl
//
//  Created by COBY_PRO on 2023/09/10.
//

import UIKit

import Moya

final class NewFeedViewModel {
    private let provider = MoyaProvider<StoreAPI>()

    func createReview(feed: Feed) async {
        guard let store = feed.store else { return }
        guard let univ = feed.univ else { return }

        let form = CreateReviewRequest(
            locationId: store.id,
            storeName: store.placeName,
            storeAddress: store.roadAddressName,
            x: Double(store.longitude)!,
            y: Double(store.latitude)!,
            storeUrl: store.placeURL,
            phone: store.phone,
            category: feed.category!,
            reviewContent: feed.comment!,
            schoolName: univ.placeName,
            schoolX: Double(univ.longitude)!,
            schoolY: Double(univ.latitude)!
        )

        let response = await provider.request(.createReview(form: form))
        switch response {
        case .success:
            print("success to create review")
        case .failure(let err):
            print(err.localizedDescription)
        }
    }
}
