//
//  GrabbarView.swift
//  FoodBowl
//
//  Created by COBY_PRO on 2023/07/25.
//

import UIKit

import SnapKit
import Then

final class GrabbarView: UIView {
    private lazy var grabbar = UIView().then {
        $0.backgroundColor = .grey002
        $0.layer.cornerRadius = 4
    }

    let modalTitleLabel = UILabel().then {
        $0.font = UIFont.preferredFont(forTextStyle: .title3, weight: .bold)
        $0.textColor = .mainText
    }

    let modalResultLabel = UILabel().then {
        $0.font = UIFont.preferredFont(forTextStyle: .subheadline, weight: .regular)
        $0.textColor = .subText
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

    func setupLayout() {
        addSubviews(grabbar, modalTitleLabel, modalResultLabel)

        grabbar.snp.makeConstraints {
            $0.top.equalToSuperview().inset(10)
            $0.centerX.equalToSuperview()
            $0.width.equalTo(50)
            $0.height.equalTo(8)
        }

        modalTitleLabel.snp.makeConstraints {
            $0.top.equalTo(grabbar.snp.bottom).offset(20)
            $0.bottom.equalToSuperview().inset(10)
            $0.leading.equalToSuperview().inset(BaseSize.horizantalPadding)
        }

        modalResultLabel.snp.makeConstraints {
            $0.top.equalTo(grabbar.snp.bottom).offset(28)
            $0.trailing.equalToSuperview().inset(BaseSize.horizantalPadding)
        }
    }

    func configureUI() {
        backgroundColor = .mainBackground
        layer.cornerRadius = 15
        layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
    }

    func showContent() {
        modalTitleLabel.isHidden = false
        modalResultLabel.snp.remakeConstraints {
            $0.top.equalTo(grabbar.snp.bottom).offset(26)
            $0.trailing.equalToSuperview().inset(BaseSize.horizantalPadding)
        }
    }

    func showResult() {
        modalTitleLabel.isHidden = true
        modalResultLabel.snp.remakeConstraints {
            $0.top.equalTo(grabbar.snp.bottom).offset(26)
            $0.centerX.equalToSuperview()
        }
    }
}
