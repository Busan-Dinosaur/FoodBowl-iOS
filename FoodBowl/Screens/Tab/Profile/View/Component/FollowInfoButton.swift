//
//  FollowInfoButton.swift
//  FoodBowl
//
//  Created by COBY_PRO on 2023/01/18.
//

import UIKit

import SnapKit
import Then

final class FollowInfoButton: UIButton {
    // MARK: - property
    let infoLabel = UILabel().then {
        $0.font = UIFont.preferredFont(forTextStyle: .callout, weight: .medium)
        $0.textColor = .subText
    }

    let numberLabel = UILabel().then {
        $0.font = UIFont.preferredFont(forTextStyle: .footnote, weight: .regular)
        $0.textColor = .subText
    }

    // MARK: - init
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupLayout()
//        configureUI()
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - life cycle
    private func setupLayout() {
        addSubviews(infoLabel, numberLabel)

        infoLabel.snp.makeConstraints {
            $0.top.bottom.equalToSuperview()
            $0.leading.equalToSuperview()
        }

        numberLabel.snp.makeConstraints {
            $0.top.bottom.trailing.equalToSuperview()
            $0.leading.equalTo(infoLabel.snp.trailing).offset(8)
            $0.trailing.equalToSuperview()
        }
    }

    private func configureUI() {
        backgroundColor = .mainBackground
        layer.cornerRadius = 10
        layer.borderWidth = 1
        layer.borderColor = UIColor.grey002.cgColor
    }
}
