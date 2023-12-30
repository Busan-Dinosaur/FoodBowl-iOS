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
    
    init() {
        self.description = "네트워크 통신에 실패하였습니다."
    }
}
