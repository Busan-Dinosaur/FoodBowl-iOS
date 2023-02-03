//
//  FeedThumnailCollectionViewCell.swift
//  FoodBowl
//
//  Created by COBY_PRO on 2022/12/23.
//

import UIKit

import SnapKit
import Then

final class FeedThumnailCollectionViewCell: BaseCollectionViewCell {
    // MARK: - property

    lazy var thumnailImageView = UIImageView().then {
        $0.backgroundColor = .grey002
        $0.clipsToBounds = true
        $0.contentMode = .scaleAspectFill
    }

    override func setupLayout() {
        contentView.addSubviews(thumnailImageView)

        thumnailImageView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
}
