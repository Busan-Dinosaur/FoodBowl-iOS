//
//  UserInfoTableViewCell.swift
//  FoodBowl
//
//  Created by COBY_PRO on 2023/01/18.
//

import UIKit

import Kingfisher
import SnapKit
import Then

final class UserInfoTableViewCell: BaseTableViewCell {
    
    var followButtonTapAction: ((UserInfoTableViewCell) -> Void)?

    // MARK: - property
    let userImageView = UIImageView().then {
        $0.image = ImageLiteral.defaultProfile
        $0.layer.cornerRadius = 20
        $0.layer.masksToBounds = true
        $0.layer.borderColor = UIColor.grey002.cgColor
        $0.layer.borderWidth = 1
    }

    let userNameLabel = UILabel().then {
        $0.font = UIFont.preferredFont(forTextStyle: .subheadline, weight: .medium)
        $0.textColor = .mainTextColor
    }

    let userFollowerLabel = UILabel().then {
        $0.font = UIFont.preferredFont(forTextStyle: .footnote, weight: .light)
        $0.textColor = .subTextColor
    }

    let followButton = FollowButton()

    // MARK: - func
    override func setupLayout() {
        contentView.addSubviews(userImageView, userNameLabel, userFollowerLabel, followButton)

        userImageView.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(SizeLiteral.horizantalPadding)
            $0.centerY.equalToSuperview()
            $0.width.height.equalTo(40)
        }

        userNameLabel.snp.makeConstraints {
            $0.leading.equalTo(userImageView.snp.trailing).offset(12)
            $0.top.equalToSuperview().inset(14)
            $0.height.equalTo(18)
        }

        userFollowerLabel.snp.makeConstraints {
            $0.leading.equalTo(userImageView.snp.trailing).offset(12)
            $0.top.equalTo(userNameLabel.snp.bottom).offset(4)
        }

        followButton.snp.makeConstraints {
            $0.trailing.equalToSuperview().inset(SizeLiteral.horizantalPadding)
            $0.centerY.equalToSuperview()
            $0.width.equalTo(50)
            $0.height.equalTo(30)
        }
    }

    override func configureUI() {
        followButton.addAction(UIAction { _ in self.followButtonTapAction?(self) }, for: .touchUpInside)
        backgroundColor = .clear
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        userImageView.image = nil
    }

    func setupData(_ member: Member) {
        self.userNameLabel.text = member.nickname
        self.userFollowerLabel.text = "팔로워 \(member.followerCount)명"
        if let url = member.profileImageUrl {
            self.userImageView.kf.setImage(with: URL(string: url))
        } else {
            self.userImageView.image = ImageLiteral.defaultProfile
        }
        
        if member.isMyProfile {
            self.followButton.isHidden = true
        } else {
            self.followButton.isHidden = false
            self.followButton.isSelected = member.isFollowing
            self.followButtonTapAction = { [weak self] _ in }
        }
    }

    func setupDataByMemberByFollow(_ member: MemberByFollowItemDTO) {
        userNameLabel.text = member.nickname
        userFollowerLabel.text = "팔로워 \(member.followerCount.prettyNumber)명"
        if let url = member.profileImageUrl {
            userImageView.kf.setImage(with: URL(string: url))
        } else {
            userImageView.image = ImageLiteral.defaultProfile
        }
    }
}
