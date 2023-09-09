//
//  CreateReviewRequest.swift
//  FoodBowl
//
//  Created by COBY_PRO on 2023/09/10.
//

import Foundation

struct CreateReviewRequest: Encodable {
    let locationId: String
    let storeName: String
    let storeAddress: String
    let x: Double
    let y: Double
    let storeUrl: String
    let phone: String
    let category: String
    let reviewContent: String
    let schoolName: String
    let schoolX: Double
    let schoolY: Double
}
