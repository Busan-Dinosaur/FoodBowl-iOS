//
//  ImageLiteral.swift
//  FoodBowl
//
//  Created by COBY_PRO on 2022/12/23.
//

import UIKit

enum ImageLiteral {
    static var friends: UIImage { .load(name: "friends") }
    static var bookmark: UIImage { .load(name: "bookmark") }
    static var univ: UIImage { .load(name: "univ") }
    static var profile: UIImage { .load(name: "profile") }
    static var search: UIImage { .load(systemName: "magnifyingglass") }

    static var bookmarkFill: UIImage { .load(name: "bookmark_fill") }

    static var btnClose: UIImage { .load(systemName: "xmark") }
    static var btnSetting: UIImage { .load(name: "settings") }
    static var btnBack: UIImage { .load(systemName: "chevron.backward") }
    static var btnDown: UIImage { .load(systemName: "chevron.down") }
    static var btnForward: UIImage { .load(systemName: "chevron.forward") }
    static var btnPlus: UIImage { .load(name: "plus") }
    static var btnOption: UIImage { .load(name: "option") }
    static var btnKakaomap: UIImage { .load(name: "kakaomap") }
    static var btnFeed: UIImage { .load(name: "feed") }

    static var defaultProfile: UIImage { .load(name: "user") }
    static var appleLogo: UIImage { .load(systemName: "apple.logo") }

    static var food1: UIImage { .load(name: "food1") }
    static var food2: UIImage { .load(name: "food2") }
    static var food3: UIImage { .load(name: "food3") }

    static var vegan: UIImage { .load(name: "vegan") }
    static var cafe: UIImage { .load(name: "cafe") }
    static var korean: UIImage { .load(name: "korean") }
    static var western: UIImage { .load(name: "western") }
    static var japanese: UIImage { .load(name: "japanese") }
    static var chinese: UIImage { .load(name: "chinese") }
    static var chicken: UIImage { .load(name: "chicken") }
    static var snack: UIImage { .load(name: "snack") }
    static var seafood: UIImage { .load(name: "seafood") }
    static var salad: UIImage { .load(name: "salad") }
}

extension UIImage {
    static func load(name: String) -> UIImage {
        guard let image = UIImage(named: name, in: nil, compatibleWith: nil) else {
            return UIImage()
        }
        image.accessibilityIdentifier = name
        return image
    }

    static func load(systemName: String) -> UIImage {
        guard let image = UIImage(systemName: systemName, compatibleWith: nil) else {
            return UIImage()
        }
        image.accessibilityIdentifier = systemName
        return image
    }

    func resize(to size: CGSize) -> UIImage {
        let image = UIGraphicsImageRenderer(size: size).image { _ in
            draw(in: CGRect(origin: .zero, size: size))
        }
        return image
    }
}

extension UIImageView {
    func load(url: URL) {
        DispatchQueue.global().async { [weak self] in
            if let data = try? Data(contentsOf: url) {
                if let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        self?.image = image
                    }
                }
            }
        }
    }
}
