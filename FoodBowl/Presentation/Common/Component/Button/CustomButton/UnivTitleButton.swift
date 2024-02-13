//
//  UnivTitleButton.swift
//  FoodBowl
//
//  Created by COBY_PRO on 2023/09/16.
//

import UIKit

import SnapKit
import Then

final class UnivTitleButton: UIButton, BaseViewType {
    
    // MARK: - ui component
    
    let label = UILabel().then {
        $0.textColor = .mainTextColor
        $0.font = UIFont.preferredFont(forTextStyle: .title2, weight: .bold)
    }
    private let downButton = DownButton()

    // MARK: - init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.baseInit()
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setupLayout() {
        self.addSubviews(
            self.label,
            self.downButton
        )

        self.label.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(14)
            $0.centerY.equalToSuperview()
            $0.width.lessThanOrEqualTo(SizeLiteral.fullWidth - 100)
            $0.height.equalTo(45)
        }

        self.downButton.snp.makeConstraints {
            $0.leading.equalTo(self.label.snp.trailing).offset(10)
            $0.centerY.equalToSuperview()
            $0.width.height.equalTo(14)
        }
    }

    func configureUI() {}
}
