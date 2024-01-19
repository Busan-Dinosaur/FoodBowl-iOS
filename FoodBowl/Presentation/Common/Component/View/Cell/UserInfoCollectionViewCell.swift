//
//  UserInfoCollectionViewCell.swift
//  FoodBowl
//
//  Created by COBY_PRO on 2023/01/18.
//

import UIKit

import Kingfisher
import SnapKit
import Then

final class UserInfoCollectionViewCell: UICollectionViewCell, BaseViewType {

    // MARK: - ui component
    
    let userImageButton = UIButton().then {
        $0.backgroundColor = .grey003
        $0.layer.cornerRadius = 20
        $0.layer.masksToBounds = true
        $0.layer.borderColor = UIColor.grey002.cgColor
        $0.layer.borderWidth = 1
    }
    let userNameButton = UIButton().then {
        $0.setTitleColor(.mainTextColor, for: .normal)
        $0.titleLabel?.font = .preferredFont(forTextStyle: .subheadline, weight: .medium)
        $0.contentHorizontalAlignment = .left
    }
    let userFollowerLabel = UILabel().then {
        $0.font = UIFont.preferredFont(forTextStyle: .footnote, weight: .light)
        $0.textColor = .subTextColor
    }
    let followButton = FollowButton()
    
    // MARK: - property
    
    var userButtonTapAction: ((UserInfoCollectionViewCell) -> Void)?
    var followButtonTapAction: ((UserInfoCollectionViewCell) -> Void)?

    // MARK: - init

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.baseInit()
        self.setupAction()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupLayout() {
        contentView.addSubviews(userImageButton, userNameButton, userFollowerLabel, followButton)

        userImageButton.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(SizeLiteral.horizantalPadding)
            $0.top.bottom.equalToSuperview().inset(12)
            $0.width.height.equalTo(40)
        }
        
        userNameButton.snp.makeConstraints {
            $0.leading.equalTo(userImageButton.snp.trailing).offset(12)
            $0.top.equalToSuperview().inset(14)
            $0.height.equalTo(18)
        }

        userFollowerLabel.snp.makeConstraints {
            $0.leading.equalTo(userImageButton.snp.trailing).offset(12)
            $0.top.equalTo(userNameButton.snp.bottom).offset(2)
        }

        followButton.snp.makeConstraints {
            $0.trailing.equalToSuperview().inset(SizeLiteral.horizantalPadding)
            $0.centerY.equalToSuperview()
            $0.width.equalTo(50)
            $0.height.equalTo(30)
        }
    }

    func configureUI() {
        self.backgroundColor = .mainBackgroundColor
    }
    
    private func setupAction() {
        userImageButton.addAction(UIAction { _ in self.userButtonTapAction?(self) }, for: .touchUpInside)
        userNameButton.addAction(UIAction { _ in self.userButtonTapAction?(self) }, for: .touchUpInside)
        followButton.addAction(UIAction { _ in self.followButtonTapAction?(self) }, for: .touchUpInside)
    }
}

// MARK: - Public - func
extension UserInfoCollectionViewCell {
    func configureCell(_ member: Member) {
        if let url = member.profileImageUrl {
            userImageButton.kf.setImage(with: URL(string: url), for: .normal)
        } else {
            userImageButton.setImage(ImageLiteral.defaultProfile, for: .normal)
        }
        
        userNameButton.setTitle(member.nickname, for: .normal)
        userFollowerLabel.text = "팔로워 \(member.followerCount)명"
    }
}
