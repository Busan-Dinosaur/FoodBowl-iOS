//
//  NewFeedViewModel.swift
//  FoodBowl
//
//  Created by COBY_PRO on 2023/09/10.
//

import UIKit

import Alamofire
import Moya

final class NewFeedViewModel {
    var newFeed = CreateReviewRequest()

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

    func searchStores(keyword: String) -> [Place] {
        var stores = [Place]()

        guard let currentLoc = LocationManager.shared.manager.location else { return stores }

        let url = "https://dapi.kakao.com/v2/local/search/keyword"

        let headers: HTTPHeaders = [
            "Content-Type": "application/x-www-form-urlencoded;charset=utf-8",
            "Authorization": "KakaoAK 855a5bf7cbbe725de0f5b6474fe8d6db"
        ]

        let parameters: [String: Any] = [
            "query": keyword,
            "x": String(currentLoc.coordinate.longitude),
            "y": String(currentLoc.coordinate.latitude),
            "page": 1,
            "size": 15,
            "category_group_code": "FD6,CE7"
        ]

        AF.request(
            url,
            method: .get,
            parameters: parameters,
            encoding: URLEncoding.default,
            headers: headers
        )
        .responseDecodable(of: PlaceResponse.self) { response in
            switch response.result {
            case .success(let data):
                stores = data.documents
            case .failure(let error):
                print("Request failed with error: \(error)")
            }
        }

        return stores
    }

    func searchUniv(store: Place) -> Place? {
        var univ: Place?
        let url = "https://dapi.kakao.com/v2/local/search/keyword"

        let headers: HTTPHeaders = [
            "Content-Type": "application/x-www-form-urlencoded;charset=utf-8",
            "Authorization": "KakaoAK 855a5bf7cbbe725de0f5b6474fe8d6db"
        ]

        let parameters: [String: Any] = [
            "query": "대학교",
            "x": store.longitude,
            "y": store.latitude,
            "page": 1,
            "size": 1,
            "radius": 3000,
            "category_group_code": "SC4"
        ]

        AF.request(
            url,
            method: .get,
            parameters: parameters,
            encoding: URLEncoding.default,
            headers: headers
        )
        .responseDecodable(of: PlaceResponse.self) { response in
            switch response.result {
            case .success(let data):
                if data.documents.count > 0 {
                    univ = data.documents[0]
                }
            case .failure(let error):
                print("Request failed with error: \(error)")
            }
        }

        return univ
    }

    func getCategory(categoryName: String) -> String {
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
}
