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
                backgroundColor = .mainTextColor
                categoryLabel.textColor = .mainBackgroundColor
            } else {
                backgroundColor = .mainBackgroundColor
                categoryLabel.textColor = .mainTextColor
            }
        }
    }

    // MARK: - property
    let categoryLabel = UILabel().then {
        $0.font = UIFont.preferredFont(forTextStyle: .footnote, weight: .light)
        $0.textColor = .mainTextColor
    }

    override func setupLayout() {
        contentView.addSubviews(categoryLabel)

        categoryLabel.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(14)
            $0.top.bottom.equalToSuperview().inset(6)
        }
    }

    override func configureUI() {
        backgroundColor = .mainBackgroundColor
        layer.cornerRadius = 14
        layer.borderWidth = 1
        layer.borderColor = UIColor.grey002.cgColor
    }
}
