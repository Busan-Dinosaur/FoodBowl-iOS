//
//  SearchMembersRequest.swift
//  FoodBowl
//
//  Created by COBY_PRO on 10/12/23.
//

import Foundation

struct SearchMembersRequest: Encodable {
    var name: String
    var size: Int?
}
