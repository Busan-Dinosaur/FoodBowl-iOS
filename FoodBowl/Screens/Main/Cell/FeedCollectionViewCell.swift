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

    lazy var userImageView = UIImageView().then {
        $0.backgroundColor = .gray
        $0.layer.cornerRadius = 20
        $0.layer.masksToBounds = true
    }

    let userNameLabel = UILabel().then {
        $0.font = UIFont.preferredFont(forTextStyle: .subheadline, weight: .medium)
        $0.textColor = .black
        $0.text = "홍길동"
    }

    let userFollowerLabel = UILabel().then {
        $0.font = UIFont.preferredFont(forTextStyle: .footnote, weight: .light)
        $0.textColor = .gray
        $0.text = "팔로워 100명"
    }

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
        contentView.addSubviews(userImageView, userNameLabel, userFollowerLabel, feedImageView, storeNameLabel, popularLabel, dateLabel)

        userImageView.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(20)
            $0.top.equalToSuperview().inset(16)
            $0.width.height.equalTo(40)
        }

        userNameLabel.snp.makeConstraints {
            $0.leading.equalTo(userImageView.snp.trailing).offset(16)
            $0.top.equalToSuperview().inset(16)
        }

        userFollowerLabel.snp.makeConstraints {
            $0.leading.equalTo(userImageView.snp.trailing).offset(16)
            $0.top.equalTo(userNameLabel.snp.bottom).offset(5)
        }

        feedImageView.snp.makeConstraints {
            $0.top.equalTo(userImageView.snp.bottom).offset(16)
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
