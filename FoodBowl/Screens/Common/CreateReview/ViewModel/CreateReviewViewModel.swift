//
//  NewFeedViewModel.swift
//  FoodBowl
//
//  Created by COBY_PRO on 2023/09/10.
//

import UIKit

import Moya

final class CreateReviewViewModel {
    var reviewRequest = CreateReviewRequest()
    var reviewImages = [UIImage]()
    var store: Place?

    private let providerKakao = MoyaProvider<KakaoAPI>()
    private let providerReview = MoyaProvider<ReviewAPI>()

    func createReview() async {
        let imagesData = reviewImages.map { $0.jpegData(compressionQuality: 0.3)! }
        let response = await providerReview.request(.createReview(request: reviewRequest, images: imagesData))
        switch response {
        case .success:
            print("Success to create Review")
        case .failure(let err):
            print(err.localizedDescription)
        }
    }

    func searchStores(keyword: String) async -> [Place] {
        guard let currentLoc = LocationManager.shared.manager.location else { return [Place]() }

        let response = await providerKakao.request(.searchStores(
            x: String(currentLoc.coordinate.longitude),
            y: String(currentLoc.coordinate.latitude),
            keyword: keyword
        ))

        switch response {
        case .success(let result):
            guard let data = try? result.map(PlaceResponse.self) else { return [Place]() }
            return data.documents
        case .failure(let err):
            print(err.localizedDescription)
            return [Place]()
        }
    }

    private func searchUniv(store: Place) async -> Place? {
        let response = await providerKakao.request(.searchUniv(x: store.longitude, y: store.latitude))
        switch response {
        case .success(let result):
            guard let data = try? result.map(PlaceResponse.self) else { return nil }
            if data.documents.count > 0 {
                return data.documents[0]
            }
            return nil
        case .failure(let err):
            print(err.localizedDescription)
            return nil
        }
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
        self.store = store
        reviewRequest.locationId = store.id
        reviewRequest.storeName = store.placeName
        reviewRequest.storeAddress = store.roadAddressName
        reviewRequest.x = Double(store.longitude) ?? 0.0
        reviewRequest.y = Double(store.latitude) ?? 0.0
        reviewRequest.storeUrl = store.placeURL
        reviewRequest.phone = store.phone
        reviewRequest.category = getCategory(categoryName: store.categoryName)

        if let univ = await searchUniv(store: store) {
            if univ.placeName.contains("대학교") || univ.placeName.contains("캠퍼스") {
                reviewRequest.schoolName = univ.placeName
                reviewRequest.schoolAddress = univ.roadAddressName
                reviewRequest.schoolX = Double(univ.longitude) ?? 0.0
                reviewRequest.schoolY = Double(univ.latitude) ?? 0.0
            }
        }
    }
}
