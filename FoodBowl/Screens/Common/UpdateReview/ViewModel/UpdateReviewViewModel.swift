//
//  UpdateReviewViewModel.swift
//  FoodBowl
//
//  Created by COBY_PRO on 2023/09/12.
//

import UIKit

import Moya

final class UpdateReviewViewModel {
    var reviewContent: String
    var images: [String]

    init(reviewContent: String, images: [String]) {
        self.reviewContent = reviewContent
        self.images = images
    }

    func updateReview() async {}
}
