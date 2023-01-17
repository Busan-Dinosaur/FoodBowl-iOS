//
//  CategoryCollectionViewCell.swift
//  FoodBowl
//
//  Created by COBY_PRO on 2023/01/15.
//

import UIKit

import SnapKit
import Then

final class CategoryCollectionViewCell: BaseCollectionViewCell {
    // MARK: - property

    let categoryLabel = UILabel().then {
        $0.font = UIFont.preferredFont(forTextStyle: .headline, weight: .light)
    }

    override func render() {
        contentView.addSubviews(categoryLabel)

        categoryLabel.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(20)
            $0.centerY.equalToSuperview()
        }
    }

    override func configUI() {
        makeBorderLayer(color: .grey002)
    }
}
