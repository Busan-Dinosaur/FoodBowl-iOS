//
//  PhotoPlusCollectionViewCell.swift
//  FoodBowl
//
//  Created by COBY_PRO on 2023/01/16.
//

import UIKit

import SnapKit
import Then

final class PhotoPlusCollectionViewCell: BaseCollectionViewCell {
    // MARK: - property

    private let plusImageView = UIImageView().then {
        $0.image = UIImage(systemName: "plus.circle.fill")
        $0.tintColor = .grey001
        $0.contentMode = .scaleAspectFill
        $0.clipsToBounds = true
        $0.makeBorderLayer(color: .grey002)
    }

    override func setupLayout() {
        contentView.addSubviews(plusImageView)

        plusImageView.snp.makeConstraints {
            $0.centerX.centerY.equalToSuperview()
            $0.width.height.equalTo(30)
        }
    }

    override func configureUI() {
        backgroundColor = .grey002
    }
}
