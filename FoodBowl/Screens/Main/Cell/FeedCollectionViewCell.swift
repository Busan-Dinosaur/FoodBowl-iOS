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
    var collapsed = true {
        didSet {
            commentView.commentLabel.numberOfLines = collapsed ? 2 : 0
            commentView.commentLabel.invalidateIntrinsicContentSize()
            commentView.commentLabel.setNeedsLayout()
            commentView.commentLabel.setNeedsDisplay()
            commentView.commentLabel.layoutIfNeeded()
        }
    }

    var images: [String] = ["image1", "image2", "image3"]

    // MARK: - property

    let userInfoView = UserInfoView()

    let storeInfoView = StoreInfoView()

    lazy var feedImageView = HorizontalScrollView(horizontalWidth: UIScreen.main.bounds.size.width, horizontalHeight: UIScreen.main.bounds.size.width)

    lazy var commentView = CommentView().then {
        let tap = UITapGestureRecognizer(target: self, action: #selector(invalidate))
        $0.commentLabel.isUserInteractionEnabled = true
        $0.commentLabel.addGestureRecognizer(tap)
    }

    override func render() {
        contentView.addSubviews(userInfoView, storeInfoView, feedImageView, commentView)

        userInfoView.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview()
            $0.height.equalTo(60)
        }

        storeInfoView.snp.makeConstraints {
            $0.top.equalTo(userInfoView.snp.bottom)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(60)
        }

        feedImageView.snp.makeConstraints {
            $0.top.equalTo(storeInfoView.snp.bottom)
            $0.width.height.equalTo(UIScreen.main.bounds.size.width)
        }

        commentView.snp.makeConstraints {
            $0.top.equalTo(feedImageView.snp.bottom)
            $0.leading.trailing.bottom.equalToSuperview()
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

    @objc private func invalidate() {
        collapsed = !collapsed
        guard let collection = superview as? UICollectionView else { return }
        collection.collectionViewLayout.invalidateLayout()
    }
}
