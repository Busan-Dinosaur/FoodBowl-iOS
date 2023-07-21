//
//  ForwardButton.swift
//  FoodBowl
//
//  Created by COBY_PRO on 2023/01/27.
//

import UIKit

final class ForwardButton: UIButton {
    // MARK: - init
    override init(frame _: CGRect) {
        super.init(frame: .init(origin: .zero, size: .init(width: 44, height: 44)))
        configureUI()
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - life cycle
    private func configureUI() {
        setImage(ImageLiteral.btnForward, for: .normal)
        tintColor = .grey001
    }
}
