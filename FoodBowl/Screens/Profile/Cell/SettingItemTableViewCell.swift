//
//  SettingItemTableViewCell.swift
//  FoodBowl
//
//  Created by COBY_PRO on 2023/01/27.
//

import UIKit

import SnapKit
import Then

final class SettingItemTableViewCell: BaseTableViewCell {
    // MARK: - property

    let menuLabel = UILabel().then {
        $0.font = UIFont.preferredFont(forTextStyle: .body, weight: .regular)
        $0.textColor = .subText
    }

    private let forwordButton = ForwordButton()

    // MARK: - func

    override func setupLayout() {
        contentView.addSubviews(menuLabel, forwordButton)

        menuLabel.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(20)
            $0.centerY.equalToSuperview()
        }

        forwordButton.snp.makeConstraints {
            $0.trailing.equalToSuperview().inset(20)
            $0.centerY.equalToSuperview()
        }
    }

    override func configureUI() {
        backgroundColor = .clear
    }
}
