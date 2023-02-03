//
//  MainButton.swift
//  FoodBowl
//
//  Created by COBY_PRO on 2022/12/23.
//

import UIKit

import SnapKit
import Then

final class MainButton: UIButton {
    // MARK: - property

    let label = UILabel().then {
        let label = UILabel()
        $0.textColor = .white
        $0.font = UIFont.preferredFont(forTextStyle: .body, weight: .medium)
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
        addSubview(label)

        label.snp.makeConstraints {
            $0.centerX.centerY.equalToSuperview()
        }
    }

    private func configureUI() {
        backgroundColor = .mainPink
        layer.cornerRadius = 30
        layer.masksToBounds = false
    }
}
