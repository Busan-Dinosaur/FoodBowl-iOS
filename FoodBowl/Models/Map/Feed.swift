//
//  Feed.swift
//  FoodBowl
//
//  Created by COBY_PRO on 2023/01/17.
//

import UIKit

// MARK: - Feed

struct Feed: Identifiable {
    var id = UUID()
    var store: Place?
    var univ: Place?
    var category: String?
    var photoes: [UIImage]?
    var comment: String?
}
