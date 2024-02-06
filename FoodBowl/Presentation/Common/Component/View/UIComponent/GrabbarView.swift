//
//  GrabbarView.swift
//  FoodBowl
//
//  Created by COBY_PRO on 2023/07/25.
//

import UIKit

import SnapKit
import Then

final class GrabbarView: UIView, BaseViewType {
    
    private let grabbar = UIView().then {
        $0.backgroundColor = .grey002
        $0.layer.cornerRadius = 4
    }

    let modalResultLabel = UILabel().then {
        $0.font = UIFont.preferredFont(forTextStyle: .subheadline, weight: .regular)
        $0.textColor = .subTextColor
        $0.text = "0개의 맛집"
    }

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
            self.grabbar,
            self.modalResultLabel
        )

        self.grabbar.snp.makeConstraints {
            $0.top.equalToSuperview().inset(10)
            $0.centerX.equalToSuperview()
            $0.width.equalTo(50)
            $0.height.equalTo(8)
        }

        self.modalResultLabel.snp.makeConstraints {
            $0.top.equalTo(self.grabbar.snp.bottom).offset(30)
            $0.leading.equalToSuperview().inset(SizeLiteral.horizantalPadding)
        }
    }

    func configureUI() {
        self.backgroundColor = .mainBackgroundColor
        self.layer.cornerRadius = 15
        self.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
    }

    func showContent() {
        self.modalResultLabel.snp.remakeConstraints {
            $0.top.equalTo(grabbar.snp.bottom).offset(30)
            $0.leading.equalToSuperview().inset(SizeLiteral.horizantalPadding)
        }
    }

    func showResult() {
        self.modalResultLabel.snp.remakeConstraints {
            $0.top.equalTo(grabbar.snp.bottom).offset(30)
            $0.centerX.equalToSuperview()
        }
    }
}
