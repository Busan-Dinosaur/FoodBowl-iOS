//
//  ImageLiteral.swift
//  FoodBowl
//
//  Created by COBY_PRO on 2022/12/23.
//

import UIKit

enum ImageLiteral {
    // MARK: - button

    static var btnMain: UIImage { .load(systemName: "house") }
    static var btnSearch: UIImage { .load(systemName: "magnifyingglass") }
    static var btnMessage: UIImage { .load(systemName: "message") }
    static var btnProfile: UIImage { .load(systemName: "person.crop.circle") }

    static var btnSetting: UIImage { .load(systemName: "gearshape") }
    static var btnBack: UIImage { .load(systemName: "chevron.backward") }
    static var btnDown: UIImage { .load(systemName: "chevron.down") }
    static var btnFoward: UIImage { .load(systemName: "chevron.forward") }
    static var btnCamera: UIImage { .load(systemName: "camera") }
    static var btnSend: UIImage { .load(systemName: "paperplane") }

    // MARK: - icon
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