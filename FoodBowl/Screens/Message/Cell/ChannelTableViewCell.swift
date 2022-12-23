//
//  ChannelTableViewCell.swift
//  FoodBowl
//
//  Created by COBY_PRO on 2022/12/23.
//

import UIKit

import SnapKit
import Then

final class ChannelTableViewCell: BaseTableViewCell {
    // MARK: - property

    lazy var chatUserImageView = UIImageView().then {
        $0.layer.cornerRadius = 20
        $0.layer.masksToBounds = true
        $0.backgroundColor = .gray
    }

    lazy var chatUserNameLabel = UILabel().then {
        $0.textColor = .mainBlack
        $0.font = .preferredFont(forTextStyle: .subheadline, weight: .bold)
        $0.text = "홍길동"
    }

    lazy var chatDateLabel = UILabel().then {
        $0.textColor = UIColor(hex: "#494949")
        $0.font = .preferredFont(forTextStyle: .caption2, weight: .light)
        $0.text = "1시간 전"
    }

    lazy var chatLastLabel = UILabel().then {
        $0.textColor = .mainBlack
        $0.font = .preferredFont(forTextStyle: .footnote, weight: .light)
        $0.text = "안녕하세요"
    }

    // MARK: - func

    override func render() {
        contentView.addSubviews(chatUserImageView, chatUserNameLabel, chatLastLabel, chatDateLabel)

        chatUserImageView.snp.makeConstraints {
            $0.width.height.equalTo(40)
            $0.leading.equalToSuperview().inset(20)
            $0.centerY.equalToSuperview()
        }

        chatUserNameLabel.snp.makeConstraints {
            $0.leading.equalTo(chatUserImageView.snp.trailing).offset(16)
            $0.top.equalToSuperview().inset(16)
        }

        chatLastLabel.snp.makeConstraints {
            $0.leading.equalTo(chatUserImageView.snp.trailing).offset(16)
            $0.bottom.equalToSuperview().inset(16)
        }

        chatDateLabel.snp.makeConstraints {
            $0.trailing.equalToSuperview().inset(20)
            $0.top.equalToSuperview().inset(16)
        }
    }
}
