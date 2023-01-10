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

    let storeNameLabel = UILabel().then {
        $0.font = UIFont.preferredFont(forTextStyle: .subheadline, weight: .medium)
        $0.textColor = .black
        $0.text = "틈새라면 홍대점"
    }

    let categoryLabel = UILabel().then {
        $0.font = UIFont.preferredFont(forTextStyle: .caption1, weight: .regular)
        $0.textColor = .subText
        $0.text = "일식"
    }

    let distanceLabel = UILabel().then {
        $0.font = UIFont.preferredFont(forTextStyle: .caption1, weight: .regular)
        $0.textColor = .subText
        $0.text = "10km"
    }

    let dateLabel = UILabel().then {
        $0.font = UIFont.preferredFont(forTextStyle: .caption1, weight: .regular)
        $0.textColor = .subText
        $0.text = "10일 전"
    }

    let chatButton = ChatButton()

    let chatLabel = UILabel().then {
        $0.font = UIFont.preferredFont(forTextStyle: .caption1, weight: .regular)
        $0.textColor = .black
        $0.textAlignment = .center
        $0.text = "10"
    }

    let scrapButton = ScrapButton()

    let scrapLabel = UILabel().then {
        $0.font = UIFont.preferredFont(forTextStyle: .caption1, weight: .regular)
        $0.textColor = .black
        $0.textAlignment = .center
        $0.text = "130"
    }

    override func render() {
        contentView.addSubviews(userInfoView, commentLabel, feedImageView, storeNameLabel, categoryLabel, distanceLabel, dateLabel, scrapButton, chatButton, scrapLabel, chatLabel)

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

        storeNameLabel.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(20)
            $0.top.equalTo(feedImageView.snp.bottom).offset(12)
        }

        categoryLabel.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(20)
            $0.top.equalTo(storeNameLabel.snp.bottom).offset(4)
        }

        distanceLabel.snp.makeConstraints {
            $0.leading.equalTo(categoryLabel.snp.trailing).offset(8)
            $0.top.equalTo(storeNameLabel.snp.bottom).offset(4)
        }

        dateLabel.snp.makeConstraints {
            $0.leading.equalTo(distanceLabel.snp.trailing).offset(8)
            $0.top.equalTo(storeNameLabel.snp.bottom).offset(4)
        }

        scrapButton.snp.makeConstraints {
            $0.trailing.equalToSuperview().inset(20)
            $0.top.equalTo(feedImageView.snp.bottom).offset(10)
        }

        scrapLabel.snp.makeConstraints {
            $0.leading.equalTo(scrapButton.snp.leading)
            $0.trailing.equalTo(scrapButton.snp.trailing)
            $0.top.equalTo(scrapButton.snp.bottom).offset(4)
        }

        chatButton.snp.makeConstraints {
            $0.trailing.equalTo(scrapButton.snp.leading).offset(-20)
            $0.top.equalTo(feedImageView.snp.bottom).offset(10)
        }

        chatLabel.snp.makeConstraints {
            $0.leading.equalTo(chatButton.snp.leading)
            $0.trailing.equalTo(chatButton.snp.trailing)
            $0.top.equalTo(chatButton.snp.bottom).offset(4)
            $0.bottom.equalToSuperview().inset(30)
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
