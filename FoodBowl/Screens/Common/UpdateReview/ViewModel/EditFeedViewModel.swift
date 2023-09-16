//
//  EditFeedViewModel.swift
//  FoodBowl
//
//  Created by COBY_PRO on 2023/09/12.
//

import UIKit

import Moya

final class EditFeedViewModel {
    var request = Request()
    var images = [UIImage]()

    private let providerKakao = MoyaProvider<KakaoAPI>()
    private let provider = MoyaProvider<StoreAPI>()

    func updateReview() async {
        let imagesData = images.map { $0.jpegData(compressionQuality: 0.5)! }
        let request = CreateReviewRequest(request: request, images: imagesData)
//        let response = await provider.request(.createReview(request: request))
//        switch response {
//        case .success:
//            print("success to create review")
//        case .failure(let err):
//            print(err.localizedDescription)
//        }
    }
}
