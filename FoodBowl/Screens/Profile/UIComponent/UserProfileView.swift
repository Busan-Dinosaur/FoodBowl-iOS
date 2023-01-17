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

    private let followerLabel = UILabel().then {
        $0.font = UIFont.preferredFont(forTextStyle: .subheadline, weight: .medium)
        $0.textColor = .black
        $0.textAlignment = .center
        $0.text = "팔로워"
    }

    private let stackTextView = UIStackView().then {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.axis = .horizontal
        $0.alignment = .center
        $0.distribution = .equalSpacing
    }

    let followerNumberLabel = UILabel().then {
        $0.font = UIFont.preferredFont(forTextStyle: .subheadline, weight: .regular)
        $0.textColor = .black
        $0.textAlignment = .center
        $0.text = "100"
    }

    private let followingLabel = UILabel().then {
        $0.font = UIFont.preferredFont(forTextStyle: .subheadline, weight: .regular)
        $0.textColor = .black
        $0.textAlignment = .center
        $0.text = "팔로잉"
    }

    let followingNumberLabel = UILabel().then {
        $0.font = UIFont.preferredFont(forTextStyle: .subheadline, weight: .regular)
        $0.textColor = .black
        $0.textAlignment = .center
        $0.text = "100"
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
        addSubviews(userImageView, stackTextView, followerNumberLabel, followingNumberLabel, followButton)

        [followerLabel, followingLabel].forEach {
            stackTextView.addArrangedSubview($0)
        }

        userImageView.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(20)
            $0.centerY.equalToSuperview()
            $0.width.height.equalTo(60)
        }

        stackTextView.snp.makeConstraints {
            $0.top.equalToSuperview().inset(30)
            $0.leading.equalTo(userImageView.snp.trailing).offset(40)
            $0.width.equalTo(120)
        }

        followerNumberLabel.snp.makeConstraints {
            $0.leading.equalTo(followerLabel.snp.leading)
            $0.trailing.equalTo(followerLabel.snp.trailing)
            $0.top.equalTo(followerLabel.snp.bottom).offset(4)
        }

        followingNumberLabel.snp.makeConstraints {
            $0.leading.equalTo(followingLabel.snp.leading)
            $0.trailing.equalTo(followingLabel.snp.trailing)
            $0.top.equalTo(followingLabel.snp.bottom).offset(4)
        }

        followButton.snp.makeConstraints {
            $0.trailing.equalToSuperview().inset(20)
            $0.centerY.equalToSuperview()
            $0.width.equalTo(60)
            $0.height.equalTo(30)
        }
    }
}
