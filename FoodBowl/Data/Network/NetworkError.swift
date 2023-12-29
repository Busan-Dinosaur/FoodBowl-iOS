//
//  NetworkError.swift
//  FoodBowl
//
//  Created by Coby on 12/29/23.
//

import Foundation

struct NetworkError: LocalizedError {
    let description: String

    init(_ description: String) {
        self.description = description
    }
}
