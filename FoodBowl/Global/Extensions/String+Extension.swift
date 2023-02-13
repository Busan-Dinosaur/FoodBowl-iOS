//
//  String+Extension.swift
//  FoodBowl
//
//  Created by COBY_PRO on 2023/01/29.
//

import UIKit

extension String {
    func drawForCluster(in rect: CGRect) {
        let attributes = [NSAttributedString.Key.foregroundColor: UIColor.black,
                          NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 14)]
        let textSize = self.size(withAttributes: attributes)
        let textRect = CGRect(x: (rect.width / 2) - (textSize.width / 2),
                              y: (rect.height / 2) - (textSize.height / 2),
                              width: textSize.width,
                              height: textSize.height)

        self.draw(in: textRect, withAttributes: attributes)
    }
}

extension String {
    var prettyDistance: String {
        guard let distance = Double(self) else { return "" }
        guard distance > -.infinity else { return "?" }
        let formatter = LengthFormatter()
        formatter.numberFormatter.maximumFractionDigits = 1
        if distance >= 1000 {
            return formatter.string(fromValue: distance / 1000, unit: LengthFormatter.Unit.kilometer)
        } else {
            let value = Double(Int(distance)) // 미터로 표시할 땐 소수점 제거
            return formatter.string(fromValue: value, unit: LengthFormatter.Unit.meter)
        }
    }
}
