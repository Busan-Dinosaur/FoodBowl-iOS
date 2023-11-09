//
//  SignResponse.swift
//  FoodBowl
//
//  Created by COBY_PRO on 2023/08/10.
//

import Foundation

struct SignDTO: Decodable {
    let accessToken: String
    let refreshToken: String
}
