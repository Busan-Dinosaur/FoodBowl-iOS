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
        $0.backgroundColor = .gray
        $0.layer.cornerRadius = 40
        $0.layer.masksToBounds = true
    }

    let userNameLabel = UILabel().then {
        $0.font = UIFont.preferredFont(forTextStyle: .subheadline, weight: .medium)
        $0.textColor = .black
        $0.text = "coby5502"
    }

    let userInfoLabel = UILabel().then {
        $0.font = UIFont.preferredFont(forTextStyle: .subheadline, weight: .light)
        $0.textColor = .black
        $0.text = "동네 맛집 탐험을 좋아하는 아저씨에요."
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
        $0.font = UIFont.preferredFont(forTextStyle: .subheadline, weight: .medium)
        $0.textColor = .black
        $0.textAlignment = .center
        $0.text = "100"
    }

    private let followingLabel = UILabel().then {
        $0.font = UIFont.preferredFont(forTextStyle: .subheadline, weight: .medium)
        $0.textColor = .black
        $0.textAlignment = .center
        $0.text = "팔로잉"
    }

    let followingNumberLabel = UILabel().then {
        $0.font = UIFont.preferredFont(forTextStyle: .subheadline, weight: .medium)
        $0.textColor = .black
        $0.textAlignment = .center
        $0.text = "100"
    }

    private let scrabLabel = UILabel().then {
        $0.font = UIFont.preferredFont(forTextStyle: .subheadline, weight: .medium)
        $0.textColor = .black
        $0.textAlignment = .center
        $0.text = "스크랩"
    }

    let scrabNumberLabel = UILabel().then {
        $0.font = UIFont.preferredFont(forTextStyle: .subheadline, weight: .medium)
        $0.textColor = .black
        $0.textAlignment = .center
        $0.text = "100"
    }

    private let stackButtonView = UIStackView().then {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.axis = .horizontal
        $0.alignment = .center
        $0.distribution = .fillEqually
        $0.spacing = 12
    }

    let leftButton = SubButton().then {
        $0.label.text = "프로필 수정"
    }

    let rightButton = SubButton().then {
        $0.label.text = "후기 남기기"
    }

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
        addSubviews(userImageView, userNameLabel, userInfoLabel, stackTextView, followerNumberLabel, followingNumberLabel, scrabNumberLabel, stackButtonView)

        [followerLabel, followingLabel, scrabLabel].forEach {
            stackTextView.addArrangedSubview($0)
        }

        [leftButton, rightButton].forEach {
            stackButtonView.addArrangedSubview($0)
        }

        userImageView.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(20)
            $0.top.equalToSuperview().inset(16)
            $0.width.height.equalTo(80)
        }

        userNameLabel.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(20)
            $0.top.equalTo(userImageView.snp.bottom).offset(20)
        }

        userInfoLabel.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(20)
            $0.top.equalTo(userNameLabel.snp.bottom).offset(8)
        }

        stackTextView.snp.makeConstraints {
            $0.leading.equalTo(userImageView.snp.trailing).offset(50)
            $0.top.trailing.equalToSuperview()
            $0.trailing.equalToSuperview().inset(20)
            $0.height.equalTo(80)
        }

        followerNumberLabel.snp.makeConstraints {
            $0.leading.equalTo(followerLabel.snp.leading)
            $0.trailing.equalTo(followerLabel.snp.trailing)
            $0.top.equalTo(followerLabel.snp.bottom).offset(8)
        }

        followingNumberLabel.snp.makeConstraints {
            $0.leading.equalTo(followingLabel.snp.leading)
            $0.trailing.equalTo(followingLabel.snp.trailing)
            $0.top.equalTo(followingLabel.snp.bottom).offset(8)
        }

        scrabNumberLabel.snp.makeConstraints {
            $0.leading.equalTo(scrabLabel.snp.leading)
            $0.trailing.equalTo(scrabLabel.snp.trailing)
            $0.top.equalTo(scrabLabel.snp.bottom).offset(8)
        }

        stackButtonView.snp.makeConstraints {
            $0.top.equalTo(userInfoLabel.snp.bottom).offset(20)
            $0.leading.trailing.equalToSuperview().inset(20)
            $0.height.equalTo(40)
        }
    }
}
