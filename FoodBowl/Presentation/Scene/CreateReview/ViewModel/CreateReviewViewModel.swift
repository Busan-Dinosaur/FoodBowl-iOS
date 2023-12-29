//
//  NewFeedViewModel.swift
//  FoodBowl
//
//  Created by COBY_PRO on 2023/09/10.
//

import UIKit

import Moya

final class CreateReviewViewModel {
    var request = CreateReviewRequestDTO()
    var reviewImages = [UIImage]()
    var store: PlaceItemDTO?

    private let providerKakao = MoyaProvider<KakaoAPI>()
    private let provider = MoyaProvider<ServiceAPI>()

    func createReview() async {
        let imagesData = reviewImages.map { $0.jpegData(compressionQuality: 0.3)! }
        request.images = imagesData
        let response = await provider.request(.createReview(request: request))
        switch response {
        case .success:
            return
        case .failure(let err):
            handleError(err)
        }
    }

    func searchStores(keyword: String) async -> [PlaceItemDTO] {
        guard let currentLoc = LocationManager.shared.manager.location else { return [PlaceItemDTO]() }

        let response = await providerKakao.request(.searchStores(
            x: String(currentLoc.coordinate.longitude),
            y: String(currentLoc.coordinate.latitude),
            keyword: keyword
        ))

        switch response {
        case .success(let result):
            guard let data = try? result.map(PlaceDTO.self) else { return [PlaceItemDTO]() }
            return data.documents
        case .failure(let err):
            handleError(err)
            return [PlaceItemDTO]()
        }
    }

    private func searchUniv(store: PlaceItemDTO) async -> PlaceItemDTO? {
        let response = await providerKakao.request(.searchUniv(x: store.longitude, y: store.latitude))
        switch response {
        case .success(let result):
            guard let data = try? result.map(PlaceDTO.self) else { return nil }
            if data.documents.count > 0 {
                return data.documents[0]
            }
            return nil
        case .failure(let err):
            handleError(err)
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

    func setStore(store: PlaceItemDTO) async {
        self.store = store
        request.locationId = store.id
        request.storeName = store.placeName
        request.storeAddress = store.roadAddressName
        request.x = Double(store.longitude)!
        request.y = Double(store.latitude)!
        request.storeUrl = store.placeURL
        request.phone = store.phone
        request.category = getCategory(categoryName: store.categoryName)

        if let univ = await searchUniv(store: store) {
            if univ.placeName.contains("대학교") || univ.placeName.contains("캠퍼스") {
                request.schoolName = univ.placeName
                request.schoolAddress = univ.roadAddressName
                request.schoolX = Double(univ.longitude)!
                request.schoolY = Double(univ.latitude)!
            }
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
