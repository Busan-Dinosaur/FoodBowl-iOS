//
//  StoreInfoTableViewCell.swift
//  FoodBowl
//
//  Created by Coby Kim on 2023/01/13.
//

import UIKit

import SnapKit
import Then

final class StoreInfoTableViewCell: BaseTableViewCell {
    // MARK: - property

    let storeNameLabel = UILabel().then {
        $0.font = UIFont.preferredFont(forTextStyle: .subheadline, weight: .medium)
        $0.textColor = .black
    }

    let storeAdressLabel = UILabel().then {
        $0.font = UIFont.preferredFont(forTextStyle: .caption1, weight: .light)
        $0.textColor = .subText
    }

    let storeDistanceLabel = UILabel().then {
        $0.font = UIFont.preferredFont(forTextStyle: .caption1, weight: .light)
        $0.textColor = .black
    }

    // MARK: - func

    override func render() {
        contentView.addSubviews(storeNameLabel, storeAdressLabel, storeDistanceLabel)

        storeNameLabel.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(20)
            $0.top.equalToSuperview().inset(12)
        }

        storeAdressLabel.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(20)
            $0.bottom.equalToSuperview().inset(12)
        }

        storeDistanceLabel.snp.makeConstraints {
            $0.trailing.equalToSuperview().inset(20)
            $0.bottom.equalToSuperview().inset(12)
        }
    }
}