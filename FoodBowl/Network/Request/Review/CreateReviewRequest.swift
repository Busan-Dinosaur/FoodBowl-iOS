//
//  CreateReviewRequest.swift
//  FoodBowl
//
//  Created by COBY_PRO on 2023/09/10.
//

import Foundation

struct CreateReviewRequest: Encodable {
    var locationId: String = ""
    var storeName: String = ""
    var storeAddress: String = ""
    var x: Double = 0.0
    var y: Double = 0.0
    var storeUrl: String = ""
    var phone: String?
    var category: String = ""
    var reviewContent: String = ""
    var schoolName: String?
    var schoolAddress: String?
    var schoolX: Double?
    var schoolY: Double?
}
