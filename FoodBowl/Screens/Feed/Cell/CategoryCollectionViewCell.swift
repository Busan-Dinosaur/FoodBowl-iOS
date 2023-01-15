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
    override var isSelected: Bool {
        didSet {
            if isSelected {
                backgroundColor = .mainBlue
                categoryLabel.textColor = .white
            } else {
                backgroundColor = .white
                categoryLabel.textColor = .black
            }
        }
    }

    // MARK: - property

    lazy var categoryLabel = UILabel().then {
        $0.font = UIFont.preferredFont(forTextStyle: .subheadline, weight: .light)
        $0.text = "한식"
    }

    override func render() {
        contentView.addSubviews(categoryLabel)

        categoryLabel.snp.makeConstraints {
            $0.centerX.centerY.equalToSuperview()
        }
    }

    override func configUI() {
        makeBorderLayer(color: .grey002)
    }
}
