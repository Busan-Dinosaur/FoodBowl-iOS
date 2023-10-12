//
//  BaseSize.swift
//  FoodBowl
//
//  Created by COBY_PRO on 2023/07/21.
//

import UIKit

enum BaseSize {
    static let horizantalPadding: CGFloat = 20
    static let bottomPadding: CGFloat = 20 + bottomAreaPadding
    static let fullWidth: CGFloat = UIScreen.main.bounds.size.width - horizantalPadding * 2
    static let collectionInset = UIEdgeInsets(
        top: 0,
        left: horizantalPadding,
        bottom: 0,
        right: -horizantalPadding
    )
    static var topAreaPadding: CGFloat {
        let scenes = UIApplication.shared.connectedScenes
        let windowScene = scenes.first as? UIWindowScene
        let window = windowScene?.windows.first
        let topPadding = window?.safeAreaInsets.top ?? 0
        return topPadding
    }

    static var bottomAreaPadding: CGFloat {
        let scenes = UIApplication.shared.connectedScenes
        let windowScene = scenes.first as? UIWindowScene
        let window = windowScene?.windows.first
        let bottomPadding = window?.safeAreaInsets.bottom ?? 0
        return bottomPadding
    }
}
