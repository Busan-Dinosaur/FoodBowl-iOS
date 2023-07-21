//
//  FollowInfoButton.swift
//  FoodBowl
//
//  Created by COBY_PRO on 2023/01/18.
//

import UIKit

import SnapKit
import Then

final class FollowInfoButton: UIButton {
    // MARK: - property
    let infoLabel = UILabel().then {
        $0.font = UIFont.preferredFont(forTextStyle: .caption1, weight: .regular)
        $0.textColor = .white
    }

    let numberLabel = UILabel().then {
        $0.font = UIFont.preferredFont(forTextStyle: .caption1, weight: .regular)
        $0.textColor = .white
    }

    // MARK: - init
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupLayout()
        configureUI()
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - life cycle
    private func setupLayout() {
        addSubviews(infoLabel, numberLabel)

        infoLabel.snp.makeConstraints {
            $0.top.bottom.equalToSuperview()
            $0.leading.equalToSuperview().inset(8)
        }

        numberLabel.snp.makeConstraints {
            $0.top.bottom.trailing.equalToSuperview()
            $0.leading.equalTo(infoLabel.snp.trailing).offset(4)
            $0.trailing.equalToSuperview().inset(8)
        }
    }

    private func configureUI() {
        backgroundColor = .mainPink
        makeBorderLayer(color: .grey002)
    }
}
