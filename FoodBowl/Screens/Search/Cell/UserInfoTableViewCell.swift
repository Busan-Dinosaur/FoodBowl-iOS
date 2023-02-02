//
//  UserInfoTableViewCell.swift
//  FoodBowl
//
//  Created by COBY_PRO on 2023/01/18.
//

import UIKit

import SnapKit
import Then

final class UserInfoTableViewCell: BaseTableViewCell {
    var userButtonTapAction: ((UserInfoTableViewCell) -> Void)?
    var followButtonTapAction: ((UserInfoTableViewCell) -> Void)?

    // MARK: - property

    lazy var userImageButton = UIButton().then {
        $0.backgroundColor = .gray
        $0.layer.cornerRadius = 20
        $0.layer.masksToBounds = true
    }

    let userNameButton = UIButton().then {
        $0.setTitle("홍길동", for: .normal)
        $0.setTitleColor(.mainText, for: .normal)
        $0.titleLabel?.font = .preferredFont(forTextStyle: .subheadline, weight: .medium)
    }

    let userFollowerLabel = UILabel().then {
        $0.font = UIFont.preferredFont(forTextStyle: .footnote, weight: .light)
        $0.textColor = .subText
        $0.text = "팔로워 100명"
    }

    let followButton = FollowButton()

    // MARK: - func

    override func render() {
        contentView.addSubviews(userImageButton, userNameButton, userFollowerLabel, followButton)

        userImageButton.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(20)
            $0.centerY.equalToSuperview()
            $0.width.height.equalTo(40)
        }

        userNameButton.snp.makeConstraints {
            $0.leading.equalTo(userImageButton.snp.trailing).offset(16)
            $0.top.equalToSuperview().inset(10)
            $0.height.equalTo(20)
        }

        userFollowerLabel.snp.makeConstraints {
            $0.leading.equalTo(userImageButton.snp.trailing).offset(16)
            $0.top.equalTo(userNameButton.snp.bottom).offset(4)
        }

        followButton.snp.makeConstraints {
            $0.trailing.equalToSuperview().inset(20)
            $0.centerY.equalToSuperview()
            $0.width.equalTo(60)
            $0.height.equalTo(30)
        }
    }

    override func configUI() {
        backgroundColor = .clear

        userImageButton.addAction(UIAction { _ in self.userButtonTapAction?(self) }, for: .touchUpInside)
        userNameButton.addAction(UIAction { _ in self.userButtonTapAction?(self) }, for: .touchUpInside)
        followButton.addAction(UIAction { _ in self.followButtonTapAction?(self) }, for: .touchUpInside)
    }
}
