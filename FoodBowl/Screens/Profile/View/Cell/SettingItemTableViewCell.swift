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
        $0.font = UIFont.preferredFont(forTextStyle: .callout, weight: .regular)
        $0.textColor = .subText
    }

    private let forwardButton = ForwardButton()

    // MARK: - func
    override func setupLayout() {
        contentView.addSubviews(menuLabel, forwardButton)

        menuLabel.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(BaseSize.horizantalPadding)
            $0.centerY.equalToSuperview()
        }

        forwardButton.snp.makeConstraints {
            $0.trailing.equalToSuperview().inset(BaseSize.horizantalPadding)
            $0.centerY.equalToSuperview()
        }
    }
}
