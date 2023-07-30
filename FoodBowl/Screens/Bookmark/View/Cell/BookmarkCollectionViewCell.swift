//
//  BookmarkCollectionViewCell.swift
//  FoodBowl
//
//  Created by COBY_PRO on 2023/07/31.
//

import UIKit

import SnapKit
import Then

final class BookmarkCollectionViewCell: BaseCollectionViewCell {
    // MARK: - property
    let regionNameLabel = UILabel().then {
        $0.font = UIFont.preferredFont(forTextStyle: .subheadline, weight: .medium)
        $0.textColor = .mainText
        $0.text = "서울"
    }

    let regionNumberLabel = UILabel().then {
        $0.font = UIFont.preferredFont(forTextStyle: .caption1, weight: .light)
        $0.textColor = .subText
        $0.text = "200개"
    }

    let switchButton = CustomSwitchButton(frame: CGRect(x: 0, y: 0, width: 60, height: 30))

    // MARK: - func
    override func setupLayout() {
        contentView.addSubviews(regionNameLabel, regionNumberLabel, switchButton)

        regionNameLabel.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(BaseSize.horizantalPadding)
            $0.top.equalToSuperview().inset(15)
        }

        regionNumberLabel.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(BaseSize.horizantalPadding)
            $0.top.equalTo(regionNameLabel.snp.bottom).offset(2)
        }

        switchButton.snp.makeConstraints {
            $0.trailing.equalToSuperview().inset(BaseSize.horizantalPadding * 2)
            $0.centerY.equalToSuperview()
        }
    }

    override func configureUI() {
        backgroundColor = .mainBackground
        makeBorderLayer(color: .grey002)
    }
}
