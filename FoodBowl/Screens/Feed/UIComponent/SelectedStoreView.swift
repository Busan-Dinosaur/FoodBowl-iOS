//
//  SelectedStoreView.swift
//  FoodBowl
//
//  Created by Coby Kim on 2023/01/13.
//

import UIKit

import SnapKit
import Then

final class SelectedStoreView: UIView {
    // MARK: - property

    let storeNameLabel = UILabel().then {
        $0.font = UIFont.preferredFont(forTextStyle: .subheadline, weight: .medium)
        $0.textColor = .black
        $0.text = "틈새라면 홍대점"
    }

    let storeAdressLabel = UILabel().then {
        $0.font = UIFont.preferredFont(forTextStyle: .caption1, weight: .light)
        $0.textColor = .subText
        $0.text = "강원도 동해시 묵호진동 15-9"
    }

    let storeDistanceLabel = UILabel().then {
        $0.font = UIFont.preferredFont(forTextStyle: .caption1, weight: .light)
        $0.textColor = .black
        $0.text = "10km"
    }

    // MARK: - init

    override init(frame: CGRect) {
        super.init(frame: frame)
        render()
        configUI()
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func render() {
        addSubviews(storeNameLabel, storeAdressLabel, storeDistanceLabel)

        storeNameLabel.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(14)
            $0.top.equalToSuperview().inset(12)
        }

        storeAdressLabel.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(14)
            $0.bottom.equalToSuperview().inset(12)
        }

        storeDistanceLabel.snp.makeConstraints {
            $0.trailing.equalToSuperview().inset(14)
            $0.bottom.equalToSuperview().inset(12)
        }
    }

    private func configUI() {
        backgroundColor = .white
        makeBorderLayer(color: .grey002)
    }
}
