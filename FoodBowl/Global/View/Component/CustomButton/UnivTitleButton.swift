//
//  UnivTitleButton.swift
//  FoodBowl
//
//  Created by COBY_PRO on 2023/09/16.
//

import UIKit

final class UnivTitleButton: UIButton {
    // MARK: - property
    let label = UILabel().then {
        $0.text = "부산대학교 금정캠퍼스"
        $0.textColor = .mainText
        $0.font = .font(.regular, ofSize: 22)
    }

    let downButton = DownButton()

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
        addSubviews(label, downButton)

        label.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(14)
            $0.centerY.equalToSuperview()
            $0.height.equalTo(45)
        }

        downButton.snp.makeConstraints {
            $0.leading.equalTo(label.snp.trailing).offset(10)
            $0.centerY.equalToSuperview()
            $0.width.height.equalTo(14)
        }
    }

    // MARK: - life cycle
    private func configureUI() {}
}
