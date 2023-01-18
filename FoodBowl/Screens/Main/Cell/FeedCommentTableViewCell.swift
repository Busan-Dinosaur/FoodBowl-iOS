//
//  FeedCommentTableViewCell.swift
//  FoodBowl
//
//  Created by COBY_PRO on 2023/01/18.
//

import UIKit

import SnapKit
import Then

final class FeedCommentTableViewCell: BaseTableViewCell {
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

    let dateLabel = UILabel().then {
        $0.font = UIFont.preferredFont(forTextStyle: .caption1, weight: .regular)
        $0.textColor = .subText
        $0.text = "10일 전"
    }

    let userCommentLabel = UILabel().then {
        $0.font = UIFont.preferredFont(forTextStyle: .footnote, weight: .light)
        $0.textColor = .subText
        $0.text = "난 별로던데"
    }

    let optionButton = MoreButton()

    // MARK: - func

    override func render() {
        contentView.addSubviews(userImageView, userNameLabel, dateLabel, userCommentLabel, optionButton)

        userImageView.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(20)
            $0.centerY.equalToSuperview()
            $0.width.height.equalTo(40)
        }

        userNameLabel.snp.makeConstraints {
            $0.leading.equalTo(userImageView.snp.trailing).offset(16)
            $0.top.equalToSuperview().inset(12)
        }

        userCommentLabel.snp.makeConstraints {
            $0.leading.equalTo(userNameLabel.snp.trailing).offset(8)
            $0.top.equalToSuperview().inset(12)
        }

        userCommentLabel.snp.makeConstraints {
            $0.leading.equalTo(userImageView.snp.trailing).offset(16)
            $0.top.equalTo(userNameLabel.snp.bottom).offset(4)
        }

        optionButton.snp.makeConstraints {
            $0.trailing.equalToSuperview().inset(20)
            $0.centerY.equalToSuperview()
        }
    }
}
