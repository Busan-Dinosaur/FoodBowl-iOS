//
//  StoreHeaderView.swift
//  FoodBowl
//
//  Created by COBY_PRO on 2023/07/22.
//

import UIKit

import SnapKit
import Then

final class StoreHeaderView: UIView {
    // MARK: - property
    let mapButton = MapButton()

    let storeNameLabel = UILabel().then {
        $0.font = UIFont.preferredFont(forTextStyle: .subheadline, weight: .medium)
        $0.textColor = .mainText
        $0.text = "틈새라면 홍대점"
    }

    let categoryLabel = UILabel().then {
        $0.font = UIFont.preferredFont(forTextStyle: .footnote, weight: .light)
        $0.textColor = .subText
        $0.text = "일식"
    }

    let storeAddressLabel = UILabel().then {
        $0.font = UIFont.preferredFont(forTextStyle: .footnote, weight: .regular)
        $0.textColor = .subText
        $0.text = "강원도 한섬로73 103동 1401호"
    }

    let distanceLabel = UILabel().then {
        $0.font = UIFont.preferredFont(forTextStyle: .footnote, weight: .light)
        $0.textColor = .subText
        $0.text = "10km"
    }

    let bookmarkButton = BookmarkButton()

    let borderLineView = UIView().then {
        $0.backgroundColor = .grey002.withAlphaComponent(0.5)
    }

    // MARK: - init
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupLayout()
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupLayout() {
        addSubviews(mapButton, storeNameLabel, categoryLabel, storeAddressLabel, bookmarkButton, borderLineView)

        mapButton.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.leading.equalToSuperview().inset(BaseSize.horizantalPadding)
        }

        storeNameLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(2)
            $0.leading.equalTo(mapButton.snp.trailing).offset(12)
        }

        categoryLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(4)
            $0.leading.equalTo(storeNameLabel.snp.trailing).offset(12)
        }

        storeAddressLabel.snp.makeConstraints {
            $0.top.equalTo(storeNameLabel.snp.bottom).offset(2)
            $0.leading.equalTo(mapButton.snp.trailing).offset(12)
        }

        bookmarkButton.snp.makeConstraints {
            $0.top.equalToSuperview().inset(10)
            $0.trailing.equalToSuperview().inset(BaseSize.horizantalPadding)
        }

        borderLineView.snp.makeConstraints {
            $0.leading.trailing.bottom.equalToSuperview()
            $0.height.equalTo(1)
        }
    }
}
