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
        $0.layer.cornerRadius = 30
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

    private let stackView = UIStackView().then {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.axis = .horizontal
        $0.alignment = .center
        $0.distribution = .equalSpacing
    }

    let mapButton = MiniButton().then {
        $0.label.text = "맛집지도"
    }

    let followButton = MiniButton()

    // MARK: - init

    override init(frame: CGRect) {
        super.init(frame: frame)
        render()
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - life cycle

    private func render() {
        addSubviews(userImageView, stackView, mapButton, followButton)

        [followerInfoButton, followingInfoButton].forEach {
            stackView.addArrangedSubview($0)
        }

        userImageView.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(20)
            $0.centerY.equalToSuperview()
            $0.width.height.equalTo(60)
        }

        stackView.snp.makeConstraints {
            $0.top.bottom.equalToSuperview()
            $0.leading.equalTo(userImageView.snp.trailing).offset(40)
            $0.width.equalTo(80)
        }

        mapButton.snp.makeConstraints {
            $0.trailing.equalTo(followButton.snp.leading).offset(-10)
            $0.centerY.equalToSuperview()
            $0.width.equalTo(60)
            $0.height.equalTo(30)
        }

        followButton.snp.makeConstraints {
            $0.trailing.equalToSuperview().inset(20)
            $0.centerY.equalToSuperview()
            $0.width.equalTo(60)
            $0.height.equalTo(30)
        }
    }
}
