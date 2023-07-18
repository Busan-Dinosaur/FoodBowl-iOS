//
//  UserInfoView.swift
//  FoodBowl
//
//  Created by COBY_PRO on 2022/12/24.
//

import UIKit

import SnapKit
import Then

final class UserInfoView: UIView {
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

    // MARK: - init

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupLayout()
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupLayout() {
        addSubviews(userImageButton, userNameButton, userFollowerLabel, followButton)

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
}
