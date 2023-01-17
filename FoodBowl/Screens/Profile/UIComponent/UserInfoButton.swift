//
//  UserInfoButton.swift
//  FoodBowl
//
//  Created by COBY_PRO on 2023/01/18.
//

import UIKit

import SnapKit
import Then

final class UserInfoButton: UIButton {
    // MARK: - property

    let infoLabel = UILabel().then {
        $0.font = UIFont.preferredFont(forTextStyle: .subheadline, weight: .regular)
        $0.textColor = .black
        $0.textAlignment = .center
        $0.text = "팔로잉"
    }

    let numberLabel = UILabel().then {
        $0.font = UIFont.preferredFont(forTextStyle: .subheadline, weight: .regular)
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
        addSubviews(infoLabel, numberLabel)

        infoLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
        }

        numberLabel.snp.makeConstraints {
            $0.top.equalTo(infoLabel.snp.bottom).offset(4)
            $0.centerX.equalToSuperview()
        }
    }
}
