//
//  HttpsResponse.swift
//  FoodBowl
//
//  Created by COBY_PRO on 2023/08/09.
//

import Foundation

struct HttpsResponse<T: Decodable>: Decodable {
    let result: Bool
    let message: String?
    let data: T
}
