//
//  UserInfoButton.swift
//  FoodBowl
//
//  Created by COBY_PRO on 2023/11/14.
//

import UIKit

import Kingfisher
import SnapKit
import Then

final class UserInfoButton: UIButton, BaseViewType {
    
    // MARK: - ui component
    
    private let userImageView = UIImageView().then {
        $0.image = ImageLiteral.defaultProfile
        $0.layer.cornerRadius = 20
        $0.layer.masksToBounds = true
        $0.layer.borderColor = UIColor.grey002.cgColor
        $0.layer.borderWidth = 1
    }
    private let userNameLabel = UILabel().then {
        $0.font = UIFont.preferredFont(forTextStyle: .subheadline, weight: .medium)
        $0.textColor = .mainTextColor
    }
    private let userFollowerLabel = UILabel().then {
        $0.font = UIFont.preferredFont(forTextStyle: .footnote, weight: .light)
        $0.textColor = .subTextColor
    }
    let optionButton = OptionButton()
    
    // MARK: - init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.baseInit()
    }
    
    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupLayout() {
        self.addSubviews(
            self.userImageView,
            self.userNameLabel, 
            self.userFollowerLabel,
            self.optionButton
        )
        
        self.snp.makeConstraints {
            $0.width.equalTo(UIScreen.main.bounds.size.width)
        }
        
        self.userImageView.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(SizeLiteral.horizantalPadding)
            $0.centerY.equalToSuperview()
            $0.width.height.equalTo(40)
        }
        
        self.userNameLabel.snp.makeConstraints {
            $0.leading.equalTo(self.userImageView.snp.trailing).offset(12)
            $0.top.equalToSuperview().inset(14)
            $0.height.equalTo(18)
        }
        
        self.userFollowerLabel.snp.makeConstraints {
            $0.leading.equalTo(self.userImageView.snp.trailing).offset(12)
            $0.top.equalTo(self.userNameLabel.snp.bottom).offset(2)
        }
        
        self.optionButton.snp.makeConstraints {
            $0.trailing.equalToSuperview()
            $0.centerY.equalToSuperview()
            $0.width.height.equalTo(50)
        }
    }
    
    func configureUI() {
        self.backgroundColor = .mainBackgroundColor
    }
}

extension UserInfoButton {
    func configureUser(_ member: Member) {
        if let url = member.profileImageUrl {
            self.userImageView.kf.setImage(with: URL(string: url))
        } else {
            self.userImageView.image = ImageLiteral.defaultProfile
        }
        
        self.userNameLabel.text = member.nickname
        self.userFollowerLabel.text = "팔로워 \(member.followerCount)명"
    }
}
