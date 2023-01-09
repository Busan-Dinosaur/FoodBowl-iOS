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
    // MARK: - property

    let userInfoView = UserInfoView()

    lazy var feedImageView = UIImageView().then {
        $0.backgroundColor = .gray
        $0.clipsToBounds = true
        $0.contentMode = .scaleAspectFill
    }

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
        contentView.addSubviews(userInfoView, feedImageView, storeNameLabel, categoryLabel, distanceLabel, dateLabel, scrapButton, chatButton, scrapLabel, chatLabel)

        userInfoView.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview()
            $0.height.equalTo(70)
        }

        feedImageView.snp.makeConstraints {
            $0.top.equalTo(userInfoView.snp.bottom)
            $0.width.height.equalTo(UIScreen.main.bounds.size.width)
        }

        storeNameLabel.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(20)
            $0.top.equalTo(feedImageView.snp.bottom).offset(16)
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
            $0.top.equalTo(feedImageView.snp.bottom).offset(14)
        }

        scrapLabel.snp.makeConstraints {
            $0.leading.equalTo(scrapButton.snp.leading)
            $0.trailing.equalTo(scrapButton.snp.trailing)
            $0.top.equalTo(scrapButton.snp.bottom).offset(4)
        }

        chatButton.snp.makeConstraints {
            $0.trailing.equalTo(scrapButton.snp.leading).offset(-20)
            $0.top.equalTo(feedImageView.snp.bottom).offset(14)
        }

        chatLabel.snp.makeConstraints {
            $0.leading.equalTo(chatButton.snp.leading)
            $0.trailing.equalTo(chatButton.snp.trailing)
            $0.top.equalTo(chatButton.snp.bottom).offset(4)
        }
    }
}
