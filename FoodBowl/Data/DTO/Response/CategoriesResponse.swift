//
//  CategoriesResponse.swift
//  FoodBowl
//
//  Created by COBY_PRO on 2023/09/10.
//

import Foundation

struct CategoriesResponse: Decodable {
    let categories: [Category]
}

struct Category: Decodable {
    let id: Int
    let name: String
}
