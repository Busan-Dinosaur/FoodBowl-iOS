//
//  SearchStoresRequest.swift
//  FoodBowl
//
//  Created by COBY_PRO on 10/12/23.
//

import Foundation

struct SearchStoresRequest: Encodable {
    var name: String
    var x: Double
    var y: Double
    var size: Int?
}
