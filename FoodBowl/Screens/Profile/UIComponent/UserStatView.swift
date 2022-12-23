//
//  UserStatView.swift
//  FoodBowl
//
//  Created by COBY_PRO on 2022/12/24.
//

import UIKit

import SnapKit
import Then

final class UserStatView: UIView {
    // MARK: - property

    private let followerLabel = UILabel().then {
        $0.font = UIFont.preferredFont(forTextStyle: .subheadline, weight: .medium)
        $0.textColor = .black
        $0.textAlignment = .center
        $0.text = "팔로워"
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
        addSubviews(followerLabel, followerNumberLabel, followingLabel, followingNumberLabel, scrabLabel, scrabNumberLabel)

        followerLabel.snp.makeConstraints {
            $0.leading.equalToSuperview()
        }

        followerNumberLabel.snp.makeConstraints {
            $0.centerX.equalTo(followingLabel.snp.center)
            $0.top.equalTo(followerLabel.snp.bottom).offset(8)
        }

        followingLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
        }

        followingNumberLabel.snp.makeConstraints {
            $0.centerX.equalTo(followingLabel.snp.center)
            $0.top.equalTo(followingLabel.snp.bottom).offset(8)
        }

        scrabLabel.snp.makeConstraints {
            $0.trailing.equalToSuperview()
        }

        scrabNumberLabel.snp.makeConstraints {
            $0.centerX.equalTo(scrabLabel.snp.center)
            $0.top.equalTo(scrabLabel.snp.bottom).offset(8)
        }
    }
}
