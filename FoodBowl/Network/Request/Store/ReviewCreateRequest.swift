//
//  ReviewCreateRequest.swift
//  FoodBowl
//
//  Created by COBY_PRO on 2023/09/10.
//

import Foundation

struct ReviewCreateRequest: Encodable {
    var locationId: String
    var storeName: String
    var storeAddress: String
    var x: Double
    var y: Double
    var storeUrl: String
    var phone: String
    var category: String
    var reviewContent: String
    var schoolName: String
    var schoolX: Double
    var schoolY: Double

    init(
        locationId: String = "",
        storeName: String = "",
        storeAddress: String = "",
        x: Double = 0.0,
        y: Double = 0.0,
        storeUrl: String = "",
        phone: String = "",
        category: String = "",
        reviewContent: String = "",
        schoolName: String = "",
        schoolX: Double = 0.0,
        schoolY: Double = 0.0
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
