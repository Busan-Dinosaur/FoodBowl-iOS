//
//  BookmarkButton.swift
//  FoodBowl
//
//  Created by COBY_PRO on 2022/12/26.
//

import UIKit

final class BookmarkButton: UIButton {
    // MARK: - init

    override init(frame _: CGRect) {
        super.init(frame: .init(origin: .zero, size: .init(width: 22, height: 22)))
        configUI()
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - life cycle

    private func configUI() {
        setImage(ImageLiteral.btnBookmark.resize(to: CGSize(width: 22, height: 22)), for: .normal)
        tintColor = .mainPink
    }
}
