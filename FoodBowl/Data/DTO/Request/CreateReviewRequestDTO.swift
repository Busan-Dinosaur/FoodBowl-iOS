//
//  CreateReviewRequestDTO.swift
//  FoodBowl
//
//  Created by COBY_PRO on 2023/09/10.
//

import Foundation

struct CreateReviewRequestDTO: Encodable {
    var locationId: String = ""
    var storeName: String = ""
    var storeAddress: String = ""
    var x: Double = 37.5667
    var y: Double = 126.9784
    var storeUrl: String = ""
    var phone: String?
    var category: String = ""
    var reviewContent: String = ""
    var schoolName: String?
    var schoolAddress: String?
    var schoolX: Double?
    var schoolY: Double?
    var images: [Data] = []
}
