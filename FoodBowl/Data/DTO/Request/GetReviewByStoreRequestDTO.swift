//
//  GetReviewByStoreRequestDTO.swift
//  FoodBowl
//
//  Created by COBY_PRO on 10/16/23.
//

import Foundation

struct GetReviewByStoreRequestDTO: Encodable {
    let storeId: Int
    let filter: String
}
