//
//  Feed.swift
//  FoodBowl
//
//  Created by COBY_PRO on 2023/01/17.
//

import UIKit

// MARK: - Feed

struct Feed {
    var id: String?
    var store: Place?
    var category: Category?
    var photoes: [UIImage]?
    var comment: String?
}

// MARK: - Category

enum Category: String, CaseIterable {
    case cafe = "카페"
    case korean = "한식"
    case western = "양식"
    case japanese = "일식"
    case chinese = "중식"
    case chicken = "치킨"
    case snack = "분식"
    case seafood = "해산물"
    case salad = "샐러드"
}
