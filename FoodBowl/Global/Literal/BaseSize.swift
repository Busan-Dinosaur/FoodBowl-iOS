//
//  BaseSize.swift
//  FoodBowl
//
//  Created by COBY_PRO on 2023/07/21.
//

import UIKit

enum BaseSize {
    static let horizantalPadding: CGFloat = 20
    static let fullWidth: CGFloat = UIScreen.main.bounds.size.width - horizantalPadding * 2
    static let collectionInset = UIEdgeInsets(
        top: 0,
        left: horizantalPadding,
        bottom: 0,
        right: horizantalPadding
    )
}
