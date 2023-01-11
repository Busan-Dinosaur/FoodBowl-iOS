//
//  FeedCollectionViewCell.swift
//  FoodBowl
//
//  Created by COBY_PRO on 2022/12/23.
//

import UIKit

import SnapKit
import Then

final class FeedCollectionViewCell: BaseCollectionViewCell {
    var images: [String] = ["image1", "image2", "image3"]

    // MARK: - property

    let userInfoView = UserInfoView()

    let commentLabel = UILabel().then {
        $0.font = UIFont.preferredFont(forTextStyle: .subheadline, weight: .light)
        $0.numberOfLines = 2
        $0.text = """
        이번에 학교 앞에 새로 생겼길래 가봤는데 너무 맛있었어요.
        """
    }

    lazy var feedImageView = HorizontalScrollView(horizontalWidth: UIScreen.main.bounds.size.width, horizontalHeight: UIScreen.main.bounds.size.width)

    let storeInfoView = StoreInfoView()

    override func render() {
        contentView.addSubviews(userInfoView, commentLabel, feedImageView, storeInfoView)

        userInfoView.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview()
            $0.height.equalTo(60)
        }

        commentLabel.snp.makeConstraints {
            $0.top.equalTo(userInfoView.snp.bottom).offset(4)
            $0.leading.trailing.equalToSuperview().inset(20)
        }

        feedImageView.snp.makeConstraints {
            $0.top.equalTo(commentLabel.snp.bottom).offset(10)
            $0.width.height.equalTo(UIScreen.main.bounds.size.width)
        }

        storeInfoView.snp.makeConstraints {
            $0.top.equalTo(feedImageView.snp.bottom)
            $0.leading.trailing.bottom.equalToSuperview()
            $0.height.equalTo(60)
        }
    }

    override func configUI() {
        super.configUI()
        feedImageView.model = [ImageLiteral.food1, ImageLiteral.food2, ImageLiteral.food3]
    }

    override func preferredLayoutAttributesFitting(_ layoutAttributes: UICollectionViewLayoutAttributes) -> UICollectionViewLayoutAttributes {
        super.preferredLayoutAttributesFitting(layoutAttributes)

        let targetSize = CGSize(width: layoutAttributes.frame.width, height: 0)

        layoutAttributes.frame.size = contentView.systemLayoutSizeFitting(targetSize, withHorizontalFittingPriority: .required, verticalFittingPriority: .fittingSizeLevel)
        print(layoutAttributes)
        return layoutAttributes
    }
}
