//
//  RenewRequest.swift
//  FoodBowl
//
//  Created by COBY_PRO on 2023/09/05.
//

import Foundation

struct RenewRequest: Encodable {
    let accessToken: String
    let refreshToken: String
}
