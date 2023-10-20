//
//  ReviewToggleButton.swift
//  FoodBowl
//
//  Created by COBY_PRO on 2023/09/15.
//

import UIKit

final class ReviewToggleButton: UIButton {
    override var isSelected: Bool {
        didSet {
            if isSelected {
                label.text = "모두"
                label.textColor = .subTextColor
            } else {
                label.text = "친구만"
                label.textColor = .mainPink
            }
        }
    }

    // MARK: - property
    private let label = UILabel().then {
        let label = UILabel()
        $0.font = UIFont.preferredFont(forTextStyle: .subheadline, weight: .medium)
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
        isSelected = true
        label.text = "모두"
        label.textColor = .subTextColor
        layer.cornerRadius = 4
        layer.borderColor = UIColor.grey002.cgColor
        layer.borderWidth = 1
    }
}
