//
//  RegionCollectionViewCell.swift
//  FoodBowl
//
//  Created by COBY_PRO on 2022/12/23.
//

import UIKit

import SnapKit
import Then

final class RegionCollectionViewCell: BaseCollectionViewCell {
    // MARK: - property

    let regionLabel = UILabel().then {
        $0.font = UIFont.preferredFont(forTextStyle: .body, weight: .semibold)
        $0.textAlignment = .center
    }

    override func render() {
        addSubview(regionLabel)

        regionLabel.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
    }

    override func configUI() {
        backgroundColor = .mainPink.withAlphaComponent(0.15)
        regionLabel.textColor = .black
        layer.masksToBounds = true
        layer.cornerRadius = 8
    }

    override var isSelected: Bool {
        willSet {
            setSelected(newValue)
        }
    }

    private func setSelected(_ selected: Bool) {
        if selected {
            backgroundColor = .mainPink
            regionLabel.textColor = .white
        } else {
            backgroundColor = .mainPink.withAlphaComponent(0.15)
            regionLabel.textColor = .black
        }
    }
}
