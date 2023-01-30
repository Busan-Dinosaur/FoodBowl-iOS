//
//  UIColor+Extension.swift
//  FoodBowl
//
//  Created by COBY_PRO on 2022/12/23.
//

import UIKit

extension UIColor {
    static var mainBackground: UIColor {
        return UIColor { traits -> UIColor in
            traits.userInterfaceStyle == .dark ?
                UIColor(hex: "#222222") :
                UIColor(hex: "#ffffff")
        }
    }
    
    static var mainText: UIColor {
        return UIColor { traits -> UIColor in
            traits.userInterfaceStyle == .dark ?
                UIColor(hex: "#ffffff") :
                UIColor(hex: "#000000")
        }
    }

    static var subText: UIColor {
        return UIColor { traits -> UIColor in
            traits.userInterfaceStyle == .dark ?
                UIColor(hex: "#E2E2E2") :
                UIColor(hex: "#494949")
        }
    }
    
    static var mainPink: UIColor {
        return UIColor(hex: "#FF689F")
    }

    static var mainBlue: UIColor {
        return UIColor(hex: "#9999CC")
    }

    static var grey001: UIColor {
        return UIColor(hex: "#B2B2B2")
    }

    static var grey002: UIColor {
        return UIColor(hex: "#E2E4E4")
    }

    static var grey003: UIColor {
        return UIColor(hex: "#EAEAEA")
    }
}

extension UIColor {
    convenience init(hex: String, alpha: CGFloat = 1.0) {
        var hexFormatted: String = hex.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines).uppercased()

        if hexFormatted.hasPrefix("#") {
            hexFormatted = String(hexFormatted.dropFirst())
        }

        assert(hexFormatted.count == 6, "Invalid hex code used.")
        var rgbValue: UInt64 = 0
        Scanner(string: hexFormatted).scanHexInt64(&rgbValue)

        self.init(red: CGFloat((rgbValue & 0xff0000) >> 16) / 255.0,
                  green: CGFloat((rgbValue & 0x00ff00) >> 8) / 255.0,
                  blue: CGFloat(rgbValue & 0x0000ff) / 255.0, alpha: alpha)
    }
}
