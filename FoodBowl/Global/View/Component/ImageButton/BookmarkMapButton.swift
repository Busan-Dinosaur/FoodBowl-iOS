//
//  BookmarkMapButton.swift
//  FoodBowl
//
//  Created by COBY_PRO on 2023/09/16.
//

import UIKit

final class BookmarkMapButton: UIButton {
    override var isSelected: Bool {
        didSet {
            if isSelected {
                setImage(
                    ImageLiteral.bookmarkFill.resize(to: CGSize(width: 20, height: 20)).withRenderingMode(.alwaysTemplate),
                    for: .normal
                )
                tintColor = .mainBackground
                backgroundColor = .mainPink
            } else {
                setImage(
                    ImageLiteral.bookmark.resize(to: CGSize(width: 20, height: 20)).withRenderingMode(.alwaysTemplate),
                    for: .normal
                )
                tintColor = .mainPink
                backgroundColor = .mainBackground
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
        setImage(ImageLiteral.bookmark.resize(to: CGSize(width: 20, height: 20)).withRenderingMode(.alwaysTemplate), for: .normal)
        tintColor = .mainPink
        backgroundColor = .mainBackground
    }
}
