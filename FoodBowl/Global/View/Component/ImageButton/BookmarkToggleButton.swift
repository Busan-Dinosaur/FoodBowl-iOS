//
//  BookmarkToggleButton.swift
//  FoodBowl
//
//  Created by COBY_PRO on 2023/09/15.
//

import UIKit

final class BookmarkToggleButton: UIButton {
    override var isSelected: Bool {
        didSet {
            if isSelected {
                setImage(
                    ImageLiteral.bookmarkFill.resize(to: CGSize(width: 20, height: 20)),
                    for: .normal
                )
            } else {
                setImage(
                    ImageLiteral.bookmark.resize(to: CGSize(width: 20, height: 20)),
                    for: .normal
                )
            }
        }
    }

    // MARK: - init
    override init(frame _: CGRect) {
        super.init(frame: .init(origin: .zero, size: .init(width: 30, height: 30)))
        configureUI()
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - life cycle
    private func configureUI() {
        setImage(ImageLiteral.bookmark.resize(to: CGSize(width: 20, height: 20)), for: .normal)
        tintColor = .mainText
//        layer.cornerRadius = 15
//        layer.borderColor = UIColor.grey002.cgColor
//        layer.borderWidth = 1
    }
}
