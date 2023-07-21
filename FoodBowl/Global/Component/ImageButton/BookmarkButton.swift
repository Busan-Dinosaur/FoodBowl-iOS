//
//  BookmarkButton.swift
//  FoodBowl
//
//  Created by COBY_PRO on 2023/07/22.
//

import UIKit

final class BookmarkButton: UIButton {
    // MARK: - init

    override init(frame _: CGRect) {
        super.init(frame: .init(origin: .zero, size: .init(width: 20, height: 20)))
        configureUI()
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - life cycle

    private func configureUI() {
        setImage(ImageLiteral.bookmark.resize(to: CGSize(width: 20, height: 20)).withRenderingMode(.alwaysTemplate), for: .normal)
        tintColor = .mainText
    }
}
