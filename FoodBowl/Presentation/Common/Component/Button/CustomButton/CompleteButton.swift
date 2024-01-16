//
//  CompleteButton.swift
//  FoodBowl
//
//  Created by COBY_PRO on 2022/12/23.
//

import UIKit

import SnapKit
import Then

final class CompleteButton: UIButton {
    
    // MARK: - ui component

    let label = UILabel().then {
        let label = UILabel()
        $0.textColor = .mainBackgroundColor
        $0.font = UIFont.preferredFont(forTextStyle: .body, weight: .medium)
        $0.text = "완료"
    }

    // MARK: - init

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupLayout()
        self.configureUI()
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - life cycle

    private func setupLayout() {
        self.addSubview(self.label)

        self.label.snp.makeConstraints {
            $0.centerX.centerY.equalToSuperview()
        }
    }

    private func configureUI() {
        self.backgroundColor = .mainTextColor
        self.layer.cornerRadius = 30
        self.layer.masksToBounds = false
    }
}
