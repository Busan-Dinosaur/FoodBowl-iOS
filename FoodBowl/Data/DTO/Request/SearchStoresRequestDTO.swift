//
//  SearchStoresRequestDTO.swift
//  FoodBowl
//
//  Created by COBY_PRO on 10/12/23.
//

import Foundation

struct SearchStoresRequestDTO: Encodable {
    let name: String
    let x: Double
    let y: Double
    let size: Int
}
