//
//  PhotoCollectionViewCell.swift
//  FoodBowl
//
//  Created by COBY_PRO on 2022/12/23.
//

import UIKit

import Kingfisher
import SnapKit
import Then

final class PhotoCollectionViewCell: BaseCollectionViewCell {
    // MARK: - property
    lazy var foodImageView = UIImageView().then {
        $0.backgroundColor = .grey002
        $0.contentMode = .scaleAspectFill
        $0.kf.setImage(with: URL(string: "https://source.unsplash.com/random/300×300?food"))
    }

    override func setupLayout() {
        contentView.addSubviews(foodImageView)

        foodImageView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }

    override func configureUI() {
        backgroundColor = .grey002
        clipsToBounds = true
        makeBorderLayer(color: .grey002)
    }
}
