//
//  UserProfileView.swift
//  FoodBowl
//
//  Created by COBY_PRO on 2022/12/24.
//

import UIKit

import SnapKit
import Then

final class UserProfileView: UIView {
    private enum Size {
        static let buttonWidth: CGFloat = (UIScreen.main.bounds.size.width - 52) / 2
        static let buttonHeight: CGFloat = 40
    }

    // MARK: - property

    lazy var userImageView = UIImageView().then {
        $0.backgroundColor = .gray
        $0.layer.cornerRadius = 40
        $0.layer.masksToBounds = true
    }

    let userInfoLabel = UILabel().then {
        $0.font = UIFont.preferredFont(forTextStyle: .subheadline, weight: .light)
        $0.textColor = .black
        $0.text = "동네 맛집 탐험을 좋아하는 아저씨에요."
    }

    let userStatView = UIStackView()

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
        addSubviews(userImageView, userInfoLabel, userStatView, leftButton, rightButton)

        userImageView.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(20)
            $0.top.equalToSuperview().inset(16)
            $0.width.height.equalTo(80)
        }

        userInfoLabel.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(20)
            $0.top.equalTo(userImageView.snp.bottom).offset(20)
        }

        userStatView.snp.makeConstraints {
            $0.leading.equalTo(userImageView.snp.trailing).offset(50)
            $0.trailing.equalToSuperview().inset(20)
            $0.top.equalTo(userImageView.snp.top)
            $0.bottom.equalTo(userImageView.snp.bottom)
        }

        leftButton.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(20)
            $0.top.equalTo(userInfoLabel.snp.bottom).offset(20)
            $0.width.equalTo(Size.buttonWidth)
            $0.height.equalTo(Size.buttonHeight)
        }

        rightButton.snp.makeConstraints {
            $0.trailing.equalToSuperview().inset(20)
            $0.top.equalTo(userInfoLabel.snp.bottom).offset(20)
            $0.width.equalTo(Size.buttonWidth)
            $0.height.equalTo(Size.buttonHeight)
        }
    }
}
