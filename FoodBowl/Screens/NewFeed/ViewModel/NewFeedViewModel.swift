//
//  NewFeedViewModel.swift
//  FoodBowl
//
//  Created by COBY_PRO on 2023/09/10.
//

import UIKit

import Moya

final class NewFeedViewModel {
    var newFeed = CreateReviewRequest()

    private let providerKakao = MoyaProvider<KakaoAPI>()
    private let provider = MoyaProvider<StoreAPI>()

    func createReview() async {
        let response = await provider.request(.createReview(form: newFeed))
        switch response {
        case .success:
            print("success to create review")
        case .failure(let err):
            print(err.localizedDescription)
        }
    }

    func searchStores(keyword: String) async -> [Place] {
        var stores = [Place]()
        guard let currentLoc = LocationManager.shared.manager.location else { return stores }

        let response = await providerKakao.request(.searchStores(
            x: String(currentLoc.coordinate.longitude),
            y: String(currentLoc.coordinate.latitude),
            keyword: keyword
        ))

        switch response {
        case .success(let result):
            guard let data = try? result.map(PlaceResponse.self) else { return stores }
            stores = data.documents
        case .failure(let err):
            print(err.localizedDescription)
        }

        return stores
    }

    private func searchUniv(store: Place) async -> Place? {
        var univ: Place?

        let response = await providerKakao.request(.searchUniv(x: store.longitude, y: store.latitude))

        switch response {
        case .success(let result):
            guard let data = try? result.map(PlaceResponse.self) else { return univ }
            if data.documents.count > 0 {
                univ = data.documents[0]
            }
        case .failure(let err):
            print(err.localizedDescription)
        }

        return univ
    }

    private func getCategory(categoryName: String) -> String {
        let categoryArray = categoryName
            .components(separatedBy: ">").map { $0.trimmingCharacters(in: .whitespaces) }
        let categories = Categories.allCases.map { $0.rawValue }

        if categoryArray.count >= 2 && categories.contains(categoryArray[1]) == true {
            if categoryArray.count >= 3 && categoryArray[2] == "해물,생선" {
                return "해산물"
            }

            return categoryArray[1]
        }
        return "기타"
    }

    func setStore(store: Place) async {
        newFeed.locationId = store.id
        newFeed.storeName = store.placeName
        newFeed.storeAddress = store.addressName
        newFeed.x = Double(store.longitude) ?? 0.0
        newFeed.y = Double(store.latitude) ?? 0.0
        newFeed.storeUrl = store.placeURL
        newFeed.phone = store.phone
        newFeed.category = getCategory(categoryName: store.categoryName)

        guard let univ = await searchUniv(store: store) else { return }
        newFeed.schoolName = univ.placeName
        newFeed.schoolX = Double(univ.longitude) ?? 0.0
        newFeed.schoolY = Double(univ.latitude) ?? 0.0
    }
}
