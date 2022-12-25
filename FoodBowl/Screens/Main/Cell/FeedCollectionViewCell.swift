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

    let popularLabel = UILabel().then {
        $0.font = UIFont.preferredFont(forTextStyle: .caption1, weight: .medium)
        $0.textColor = .gray
        $0.text = "스크랩 30회  댓글 4개"
    }

    let dateLabel = UILabel().then {
        $0.font = UIFont.preferredFont(forTextStyle: .caption1, weight: .medium)
        $0.textColor = .gray
        $0.text = "10일 전"
    }

    override func render() {
        contentView.addSubviews(userInfoView, feedImageView, storeNameLabel, popularLabel, dateLabel)

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

        popularLabel.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(20)
            $0.top.equalTo(storeNameLabel.snp.bottom).offset(5)
        }

        dateLabel.snp.makeConstraints {
            $0.trailing.equalToSuperview().inset(20)
            $0.top.equalTo(storeNameLabel.snp.bottom).offset(5)
        }
    }
}
