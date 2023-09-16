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
        addSubviews(grabbar, modalResultLabel)

        grabbar.snp.makeConstraints {
            $0.top.equalToSuperview().inset(10)
            $0.centerX.equalToSuperview()
            $0.width.equalTo(50)
            $0.height.equalTo(8)
        }

        modalResultLabel.snp.makeConstraints {
            $0.top.equalTo(grabbar.snp.bottom).offset(30)
            $0.leading.equalToSuperview().inset(BaseSize.horizantalPadding)
        }
    }

    func configureUI() {
        backgroundColor = .mainBackground
        layer.cornerRadius = 15
        layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
    }

    func showContent() {
        modalResultLabel.snp.remakeConstraints {
            $0.top.equalTo(grabbar.snp.bottom).offset(30)
            $0.leading.equalToSuperview().inset(BaseSize.horizantalPadding)
        }
    }

    func showResult() {
        modalResultLabel.snp.remakeConstraints {
            $0.top.equalTo(grabbar.snp.bottom).offset(30)
            $0.centerX.equalToSuperview()
        }
    }
}
