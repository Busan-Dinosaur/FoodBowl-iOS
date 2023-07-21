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
                backgroundColor = .mainText
                categoryLabel.textColor = .mainBackground
            } else {
                backgroundColor = .mainBackground
                categoryLabel.textColor = .mainText
            }
        }
    }

    // MARK: - property

    let categoryLabel = UILabel().then {
        $0.font = UIFont.preferredFont(forTextStyle: .footnote, weight: .light)
        $0.textColor = .mainText
    }

    override func setupLayout() {
        contentView.addSubviews(categoryLabel)

        categoryLabel.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(14)
            $0.top.bottom.equalToSuperview().inset(7)
        }
    }

    override func configureUI() {
        backgroundColor = .mainBackground
        layer.cornerRadius = 15
        layer.borderWidth = 1
        layer.borderColor = UIColor.grey002.cgColor
    }
}
