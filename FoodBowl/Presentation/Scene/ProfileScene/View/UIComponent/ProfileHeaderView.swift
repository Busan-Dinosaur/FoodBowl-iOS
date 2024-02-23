//
//  ProfileHeaderView.swift
//  FoodBowl
//
//  Created by COBY_PRO on 2022/12/24.
//

import UIKit

import SnapKit
import Then

final class ProfileHeaderView: UIView, BaseViewType {
    
    // MARK: - ui component
    
    let userImageView = UIImageView().then {
        $0.image = ImageLiteral.defaultProfile
        $0.layer.cornerRadius = 25
        $0.layer.masksToBounds = true
        $0.layer.borderColor = UIColor.grey002.cgColor
        $0.layer.borderWidth = 1
    }
    let followerInfoButton = FollowInfoButton().then {
        $0.infoLabel.text = "팔로워"
    }
    let followingInfoButton = FollowInfoButton().then {
        $0.infoLabel.text = "팔로잉"
    }
    let userInfoLabel = UILabel().then {
        $0.font = UIFont.preferredFont(forTextStyle: .footnote, weight: .regular)
        $0.textColor = .mainTextColor
        $0.numberOfLines = 1
    }
    let followButton = FollowButton()
    let editButton = EditButton()

    // MARK: - init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.baseInit()
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - base func

    func setupLayout() {
        self.addSubviews(
            self.userImageView,
            self.followerInfoButton,
            self.followingInfoButton,
            self.userInfoLabel,
            self.followButton,
            self.editButton
        )

        self.userImageView.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(SizeLiteral.horizantalPadding)
            $0.top.equalToSuperview()
            $0.width.height.equalTo(50)
        }

        self.followerInfoButton.snp.makeConstraints {
            $0.leading.equalTo(userImageView.snp.trailing).offset(14)
            $0.top.equalToSuperview().inset(4)
            $0.height.equalTo(20)
        }

        self.followingInfoButton.snp.makeConstraints {
            $0.leading.equalTo(self.followerInfoButton.snp.trailing).offset(12)
            $0.top.equalToSuperview().inset(4)
            $0.height.equalTo(20)
        }

        self.userInfoLabel.snp.makeConstraints {
            $0.leading.equalTo(userImageView.snp.trailing).offset(14)
            $0.top.equalTo(self.followerInfoButton.snp.bottom).offset(6)
            $0.width.equalTo(SizeLiteral.fullWidth - 140)
        }

        self.followButton.snp.makeConstraints {
            $0.top.equalToSuperview().inset(10)
            $0.trailing.equalToSuperview().inset(SizeLiteral.horizantalPadding)
            $0.width.equalTo(60)
            $0.height.equalTo(30)
        }

        self.editButton.snp.makeConstraints {
            $0.top.equalToSuperview().inset(10)
            $0.trailing.equalToSuperview().inset(SizeLiteral.horizantalPadding)
            $0.width.equalTo(50)
            $0.height.equalTo(30)
        }
    }

    func configureUI() {
        self.backgroundColor = .mainBackgroundColor
    }
}
