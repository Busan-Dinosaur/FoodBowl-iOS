//
//  BaseSize.swift
//  FoodBowl
//
//  Created by COBY_PRO on 2023/07/21.
//

import UIKit

enum BaseSize {
    static let leadingTrailingPadding: CGFloat = 20
    static let fullWidth: CGFloat = UIScreen.main.bounds.size.width - leadingTrailingPadding * 2
    static let collectionInset = UIEdgeInsets(
        top: 0,
        left: leadingTrailingPadding,
        bottom: 0,
        right: leadingTrailingPadding
    )
}
