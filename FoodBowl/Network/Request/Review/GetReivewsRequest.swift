//
//  GetReivewsRequest.swift
//  FoodBowl
//
//  Created by COBY_PRO on 10/12/23.
//

import Foundation

struct GetReviewsRequest: Encodable {
    var lastReviewId: Int?
    var x: Double
    var y: Double
    var deltaX: Double
    var deltaY: Double
    var deviceX: Double
    var deviceY: Double
    var pageSize: Int?
}
