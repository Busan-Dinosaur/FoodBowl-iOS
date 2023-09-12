//
//  NewFeedViewModel.swift
//  FoodBowl
//
//  Created by COBY_PRO on 2023/09/10.
//

import UIKit

import Moya

final class NewFeedViewModel {
    var request = Request()
    var images = [UIImage]()

    private let providerKakao = MoyaProvider<KakaoAPI>()
    private let provider = MoyaProvider<StoreAPI>()

    func createReview() async {
        let imagesData = images.map { $0.jpegData(compressionQuality: 1.0)! }
        let request = CreateReviewRequest(request: request, images: imagesData)
        let response = await provider.request(.createReview(request: request))
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
        } else if categoryArray.count >= 3 && categoryArray[2] == "제과,베이커리" {
            return "카페"
        }

        return "기타"
    }

    func setStore(store: Place) async {
        request.locationId = store.id
        request.storeName = store.placeName
        request.storeAddress = store.addressName
        request.x = Double(store.longitude) ?? 0.0
        request.y = Double(store.latitude) ?? 0.0
        request.storeUrl = store.placeURL
        request.phone = store.phone
        request.category = getCategory(categoryName: store.categoryName)

        guard let univ = await searchUniv(store: store) else { return }
        request.schoolName = univ.placeName
        request.schoolX = Double(univ.longitude) ?? 0.0
        request.schoolY = Double(univ.latitude) ?? 0.0
    }
}
