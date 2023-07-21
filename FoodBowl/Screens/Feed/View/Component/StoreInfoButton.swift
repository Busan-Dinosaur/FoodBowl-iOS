//
//  StoreInfoView.swift
//  FoodBowl
//
//  Created by COBY_PRO on 2022/12/26.
//

import UIKit

import SnapKit
import Then

final class StoreInfoButton: UIButton {
    // MARK: - property
    let storeNameLabel = UILabel().then {
        $0.font = UIFont.preferredFont(forTextStyle: .footnote, weight: .medium)
        $0.textColor = .subText
        $0.text = "틈새라면 홍대점"
    }

    let categoryLabel = UILabel().then {
        $0.font = UIFont.preferredFont(forTextStyle: .caption2, weight: .regular)
        $0.textColor = .subText
        $0.text = "일식"
    }

    let distanceLabel = UILabel().then {
        $0.font = UIFont.preferredFont(forTextStyle: .caption2, weight: .regular)
        $0.textColor = .subText
        $0.text = "10km"
    }

    let bookmarkButton = BookmarkButton()

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

    private func setupLayout() {
        addSubviews(storeNameLabel, categoryLabel, distanceLabel, bookmarkButton)

        storeNameLabel.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(14)
            $0.top.equalToSuperview().inset(12)
        }

        categoryLabel.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(14)
            $0.top.equalTo(storeNameLabel.snp.bottom).offset(4)
        }

        distanceLabel.snp.makeConstraints {
            $0.leading.equalTo(categoryLabel.snp.trailing).offset(8)
            $0.top.equalTo(storeNameLabel.snp.bottom).offset(4)
        }

        bookmarkButton.snp.makeConstraints {
            $0.trailing.equalToSuperview().inset(14)
            $0.centerY.equalToSuperview()
        }
    }

    private func configureUI() {
        makeBorderLayer(color: .grey002)
    }
}
