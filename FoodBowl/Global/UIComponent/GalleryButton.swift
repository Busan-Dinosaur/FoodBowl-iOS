//
//  GalleryButton.swift
//  FoodBowl
//
//  Created by COBY_PRO on 2023/01/16.
//

import UIKit

final class GalleryButton: UIButton {
    // MARK: - init

    override init(frame _: CGRect) {
        super.init(frame: .init(origin: .zero, size: .init(width: 22, height: 22)))
        configureUI()
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - life cycle

    private func configureUI() {
        setImage(
            ImageLiteral.btnGallery.resize(to: CGSize(width: 22, height: 22)).withRenderingMode(.alwaysTemplate),
            for: .normal
        )
        tintColor = .mainText
    }
}
