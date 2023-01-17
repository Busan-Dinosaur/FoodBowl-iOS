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

    let categoryLabel = UILabel().then {
        $0.font = UIFont.preferredFont(forTextStyle: .headline, weight: .light)
    }

    override func render() {
        contentView.addSubviews(categoryLabel)

        categoryLabel.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(20)
            $0.top.bottom.equalToSuperview().inset(10)
        }
    }

    override func configUI() {
        backgroundColor = .white
        makeBorderLayer(color: .grey002)
    }
}
