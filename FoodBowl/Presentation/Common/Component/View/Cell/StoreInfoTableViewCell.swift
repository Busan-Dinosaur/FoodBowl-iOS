//
//  StoreInfoTableViewCell.swift
//  FoodBowl
//
//  Created by COBY_PRO on 2023/01/18.
//

import UIKit

import SnapKit
import Then

final class StoreInfoTableViewCell: BaseTableViewCell {
    // MARK: - property
    let storeNameLabel = UILabel().then {
        $0.font = UIFont.preferredFont(forTextStyle: .subheadline, weight: .medium)
        $0.textColor = .mainTextColor
    }

    let storeFeedLabel = UILabel().then {
        $0.font = UIFont.preferredFont(forTextStyle: .caption1, weight: .light)
        $0.textColor = .subTextColor
    }

    let storeDistanceLabel = UILabel().then {
        $0.font = UIFont.preferredFont(forTextStyle: .caption1, weight: .light)
        $0.textColor = .mainTextColor
    }

    // MARK: - func
    override func setupLayout() {
        contentView.addSubviews(storeNameLabel, storeFeedLabel, storeDistanceLabel)

        storeNameLabel.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(BaseSize.horizantalPadding)
            $0.top.equalToSuperview().inset(15)
        }

        storeFeedLabel.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(BaseSize.horizantalPadding)
            $0.top.equalTo(storeNameLabel.snp.bottom).offset(2)
        }

        storeDistanceLabel.snp.makeConstraints {
            $0.trailing.equalToSuperview().inset(BaseSize.horizantalPadding)
            $0.top.equalTo(storeNameLabel.snp.bottom).offset(2)
        }
    }

    override func configureUI() {
        backgroundColor = .clear
    }

    func setupData(_ store: StoreBySearch) {
        storeNameLabel.text = store.storeName
        storeFeedLabel.text = "\(store.reviewCount.prettyNumber)명이 후기를 남겼어요."
        storeDistanceLabel.text = store.distance.prettyDistance
    }
}
