//
//  StoreInfoView.swift
//  FoodBowl
//
//  Created by COBY_PRO on 2022/12/26.
//

import UIKit

import SnapKit
import Then

final class StoreInfoView: UIView {
    // MARK: - property

    let storeNameButton = UIButton().then {
        $0.setTitle("틈새라면 홍대점", for: .normal)
        $0.setTitleColor(.black, for: .normal)
        $0.titleLabel?.font = .preferredFont(forTextStyle: .subheadline, weight: .medium)
    }

    let categoryLabel = UILabel().then {
        $0.font = UIFont.preferredFont(forTextStyle: .caption1, weight: .regular)
        $0.textColor = .subText
        $0.text = "일식"
    }

    let distanceLabel = UILabel().then {
        $0.font = UIFont.preferredFont(forTextStyle: .caption1, weight: .regular)
        $0.textColor = .subText
        $0.text = "10km"
    }

    let mapButton = UIButton().then {
        $0.setImage(ImageLiteral.btnKakaomap, for: .normal)
        $0.clipsToBounds = true
        $0.layer.cornerRadius = 10
    }

    // MARK: - init

    override init(frame: CGRect) {
        super.init(frame: frame)
        render()
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func render() {
        addSubviews(storeNameButton, categoryLabel, distanceLabel, mapButton)

        storeNameButton.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(20)
            $0.top.equalToSuperview().inset(12)
            $0.height.equalTo(20)
        }

        categoryLabel.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(20)
            $0.top.equalTo(storeNameButton.snp.bottom).offset(4)
        }

        distanceLabel.snp.makeConstraints {
            $0.leading.equalTo(categoryLabel.snp.trailing).offset(8)
            $0.top.equalTo(storeNameButton.snp.bottom).offset(4)
        }

        mapButton.snp.makeConstraints {
            $0.trailing.equalToSuperview().inset(20)
            $0.centerY.equalToSuperview()
            $0.width.height.equalTo(33)
        }
    }
}
