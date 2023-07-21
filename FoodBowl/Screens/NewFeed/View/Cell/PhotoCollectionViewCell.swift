//
//  PhotoCollectionViewCell.swift
//  FoodBowl
//
//  Created by COBY_PRO on 2022/12/23.
//

import UIKit

import SnapKit
import Then

final class PhotoCollectionViewCell: BaseCollectionViewCell {
    // MARK: - property

    lazy var foodImageView = UIImageView().then {
        $0.backgroundColor = .grey002
        $0.clipsToBounds = true
        $0.contentMode = .scaleAspectFill
        $0.makeBorderLayer(color: .grey002)
    }

    override func setupLayout() {
        contentView.addSubviews(foodImageView)

        foodImageView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
}
