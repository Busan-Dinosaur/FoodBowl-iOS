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
        layer.cornerRadius = 10
        layer.borderWidth = 1
        layer.borderColor = color.cgColor
        return self
    }

    func fadeIn(
        duration: TimeInterval = 0.4,
        delay: TimeInterval = 0.0,
        completion: @escaping ((Bool) -> Void) = { (_: Bool) in }
    ) {
        UIView.animate(
            withDuration: duration,
            delay: delay,
            options: .curveEaseIn,
            animations: {
                self.alpha = 1.0
            },
            completion: completion
        )
    }

    func showAnimation(_ completionBlock: @escaping () -> Void) {
        isUserInteractionEnabled = false
        UIView.animate(
            withDuration: 0.1,
            delay: 0,
            options: .curveLinear,
            animations: { [weak self] in
                self?.transform = CGAffineTransform(scaleX: 0.95, y: 0.95)
            }
        ) { _ in
            UIView.animate(
                withDuration: 0.1,
                delay: 0,
                options: .curveLinear,
                animations: { [weak self] in
                    self?.transform = CGAffineTransform(scaleX: 1, y: 1)
                }
            ) { [weak self] _ in
                self?.isUserInteractionEnabled = true
                completionBlock()
            }
        }
    }

    func addSubviews(_ views: UIView...) {
        for view in views {
            addSubview(view)
        }
    }
}
