//
//  UserProfileView.swift
//  FoodBowl
//
//  Created by COBY_PRO on 2022/12/24.
//

import UIKit

import SnapKit
import Then

final class UserProfileView: UICollectionReusableView {
    // MARK: - property

    lazy var userImageView = UIImageView().then {
        $0.backgroundColor = .grey001
        $0.layer.cornerRadius = 40
        $0.layer.masksToBounds = true
    }

    let followerInfoButton = UserInfoButton().then {
        $0.infoLabel.text = "팔로워"
        $0.numberLabel.text = "100"
    }

    let followingInfoButton = UserInfoButton().then {
        $0.infoLabel.text = "팔로잉"
        $0.numberLabel.text = "100"
    }

    let followButton = FollowButton()

    let editButton = UIButton().then {
        $0.setTitle("프로필 수정", for: .normal)
        $0.setTitleColor(.white, for: .normal)
        $0.titleLabel?.font = UIFont.preferredFont(forTextStyle: .footnote, weight: .medium)
        $0.layer.cornerRadius = 15
        $0.backgroundColor = .mainBlue
    }

    // MARK: - init

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupLayout()
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - life cycle

    private func setupLayout() {
        addSubviews(userImageView, followerInfoButton, followingInfoButton, followButton, editButton)

        userImageView.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(20)
            $0.centerY.equalToSuperview()
            $0.width.height.equalTo(80)
        }

        followerInfoButton.snp.makeConstraints {
            $0.leading.equalTo(userImageView.snp.trailing).offset(40)
            $0.top.bottom.equalToSuperview()
        }

        followingInfoButton.snp.makeConstraints {
            $0.leading.equalTo(followerInfoButton.snp.trailing).offset(40)
            $0.top.bottom.equalToSuperview()
        }

        followButton.snp.makeConstraints {
            $0.trailing.equalToSuperview().inset(20)
            $0.centerY.equalToSuperview()
            $0.width.equalTo(60)
            $0.height.equalTo(30)
        }

        editButton.snp.makeConstraints {
            $0.trailing.equalToSuperview().inset(20)
            $0.centerY.equalToSuperview()
            $0.width.equalTo(80)
            $0.height.equalTo(30)
        }
    }
}
