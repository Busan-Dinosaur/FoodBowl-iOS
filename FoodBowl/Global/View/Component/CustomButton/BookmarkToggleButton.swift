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
                label.text = "북마크 On"
                label.textColor = .mainPink
            } else {
                label.text = "북마크 Off"
                label.textColor = .subText
            }
        }
    }

    // MARK: - property
    private let label = UILabel().then {
        let label = UILabel()
        $0.text = "북마크 On"
        $0.textColor = .subText
        $0.font = UIFont.preferredFont(forTextStyle: .subheadline, weight: .regular)
    }

    // MARK: - init
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupLayout()
        configureUI()
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - life cycle
    private func setupLayout() {
        addSubviews(label)

        snp.makeConstraints {
            $0.width.equalTo(80)
            $0.height.equalTo(30)
        }

        label.snp.makeConstraints {
            $0.centerX.centerY.equalToSuperview()
        }
    }

    // MARK: - life cycle
    private func configureUI() {
        tintColor = .mainText
        layer.cornerRadius = 4
        layer.borderColor = UIColor.grey002.cgColor
        layer.borderWidth = 1
    }
}
