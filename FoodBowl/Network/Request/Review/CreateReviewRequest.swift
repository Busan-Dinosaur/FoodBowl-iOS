//
//  CreateReviewRequest.swift
//  FoodBowl
//
//  Created by COBY_PRO on 2023/09/10.
//

import UIKit

struct CreateReviewRequest: Encodable {
    let request: ReviewRequest
    let images: [Data]
}

struct ReviewRequest: Encodable {
    var locationId: String
    var storeName: String
    var storeAddress: String
    var x: Double
    var y: Double
    var storeUrl: String
    var phone: String?
    var category: String
    var reviewContent: String
    var schoolName: String?
    var schoolX: Double?
    var schoolY: Double?

    init(
        locationId: String = "",
        storeName: String = "",
        storeAddress: String = "",
        x: Double = 0.0,
        y: Double = 0.0,
        storeUrl: String = "",
        phone: String? = nil,
        category: String = "",
        reviewContent: String = "",
        schoolName: String? = nil,
        schoolX: Double? = nil,
        schoolY: Double? = nil
    ) {
        self.locationId = locationId
        self.storeName = storeName
        self.storeAddress = storeAddress
        self.x = x
        self.y = y
        self.storeUrl = storeUrl
        self.phone = phone
        self.category = category
        self.reviewContent = reviewContent
        self.schoolName = schoolName
        self.schoolX = schoolX
        self.schoolY = schoolY
    }
}
