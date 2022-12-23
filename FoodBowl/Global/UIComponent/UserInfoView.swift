//
//  UserInfoView.swift
//  FoodBowl
//
//  Created by COBY_PRO on 2022/12/24.
//

import UIKit

import SnapKit
import Then

final class UserInfoView: UIView {
    // MARK: - property

    lazy var userImageView = UIImageView().then {
        $0.backgroundColor = .gray
        $0.layer.cornerRadius = 20
        $0.layer.masksToBounds = true
    }

    let userNameLabel = UILabel().then {
        $0.font = UIFont.preferredFont(forTextStyle: .subheadline, weight: .medium)
        $0.textColor = .black
        $0.text = "홍길동"
    }

    let userFollowerLabel = UILabel().then {
        $0.font = UIFont.preferredFont(forTextStyle: .footnote, weight: .light)
        $0.textColor = .gray
        $0.text = "팔로워 100명"
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

    private func render() {
        addSubviews(userImageView, userNameLabel, userFollowerLabel)

        userImageView.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(20)
            $0.centerY.equalToSuperview()
            $0.width.height.equalTo(40)
        }

        userNameLabel.snp.makeConstraints {
            $0.leading.equalTo(userImageView.snp.trailing).offset(16)
            $0.top.equalToSuperview().inset(16)
        }

        userFollowerLabel.snp.makeConstraints {
            $0.leading.equalTo(userImageView.snp.trailing).offset(16)
            $0.top.equalTo(userNameLabel.snp.bottom).offset(5)
        }
    }
}
