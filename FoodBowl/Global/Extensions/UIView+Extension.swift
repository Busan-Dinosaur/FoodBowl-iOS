//
//  UIView+Extension.swift
//  FoodBowl
//
//  Created by COBY_PRO on 2022/12/23.
//

import UIKit

extension UIView {
    var viewController: UIViewController? {
        if let nextResponder = next as? UIViewController {
            return nextResponder
        } else if let nextResponder = next as? UIView {
            return nextResponder.viewController
        } else {
            return nil
        }
    }

    @discardableResult
    func makeShadow(
        color: UIColor,
        opacity: Float,
        offset: CGSize,
        radius: CGFloat
    ) -> Self {
        layer.shadowColor = color.cgColor
        layer.shadowOpacity = opacity
        layer.shadowOffset = offset
        layer.shadowRadius = radius
        return self
    }

    @discardableResult
    func makeBorderLayer(color: UIColor) -> Self {
        layer.cornerRadius = 20
        layer.borderWidth = 1
        layer.borderColor = color.cgColor
        return self
    }

    func addSubviews(_ views: UIView...) {
        for view in views {
            addSubview(view)
        }
    }

    func roundCorners(corners: UIRectCorner, radius: CGFloat) {
        let path = UIBezierPath(
            roundedRect: bounds,
            byRoundingCorners: corners,
            cornerRadii: CGSize(width: radius, height: radius)
        )
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        layer.mask = mask
    }

    var parentViewController: MapViewController? {
        var parentResponder: UIResponder? = self
        while parentResponder != nil {
            parentResponder = parentResponder!.next
            if let viewController = parentResponder as? MapViewController {
                return viewController
            }
        }
        return nil
    }
}
