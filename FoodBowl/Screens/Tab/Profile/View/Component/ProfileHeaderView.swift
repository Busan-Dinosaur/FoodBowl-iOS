//
//  ProfileHeaderView.swift
//  FoodBowl
//
//  Created by COBY_PRO on 2022/12/24.
//

import UIKit

import SnapKit
import Then

final class ProfileHeaderView: UICollectionReusableView {
    // MARK: - property
    let userImageView = UIImageView().then {
        $0.image = ImageLiteral.defaultProfile
        $0.layer.cornerRadius = 25
        $0.layer.masksToBounds = true
        $0.layer.borderColor = UIColor.grey002.cgColor
        $0.layer.borderWidth = 1
    }

    let followerInfoButton = FollowInfoButton().then {
        $0.infoLabel.text = "팔로워"
        $0.numberLabel.text = "100"
    }

    let followingInfoButton = FollowInfoButton().then {
        $0.infoLabel.text = "팔로잉"
        $0.numberLabel.text = "30"
    }

    let userInfoLabel = UILabel().then {
        $0.font = UIFont.preferredFont(forTextStyle: .footnote, weight: .regular)
        $0.text = "중국음식을 좋아하는 김코비입니다."
        $0.textColor = .mainText
        $0.numberOfLines = 1
    }

    let followButton = FollowButton()

    let editButton = EditButton()

    // MARK: - init
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupLayout()
        configureUI()
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - life cycle

    private func setupLayout() {
        addSubviews(
            userImageView,
            followerInfoButton,
            followingInfoButton,
            userInfoLabel,
            followButton,
            editButton
        )

        userImageView.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(BaseSize.horizantalPadding)
            $0.top.equalToSuperview()
            $0.width.height.equalTo(50)
        }

        followerInfoButton.snp.makeConstraints {
            $0.leading.equalTo(userImageView.snp.trailing).offset(BaseSize.horizantalPadding)
            $0.top.equalToSuperview().inset(4)
            $0.height.equalTo(20)
        }

        followingInfoButton.snp.makeConstraints {
            $0.leading.equalTo(followerInfoButton.snp.trailing).offset(20)
            $0.top.equalToSuperview().inset(4)
            $0.height.equalTo(20)
        }

        userInfoLabel.snp.makeConstraints {
            $0.leading.equalTo(userImageView.snp.trailing).offset(20)
            $0.top.equalTo(followerInfoButton.snp.bottom).offset(6)
            $0.width.equalTo(BaseSize.fullWidth - 140)
        }

        followButton.snp.makeConstraints {
            $0.top.equalToSuperview().inset(10)
            $0.trailing.equalToSuperview().inset(BaseSize.horizantalPadding)
            $0.width.equalTo(50)
            $0.height.equalTo(30)
        }

        editButton.snp.makeConstraints {
            $0.top.equalToSuperview().inset(10)
            $0.trailing.equalToSuperview().inset(BaseSize.horizantalPadding)
            $0.width.equalTo(50)
            $0.height.equalTo(30)
        }
    }

    private func configureUI() {
        backgroundColor = .mainBackground
    }
}
