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

    let storeNameLabel = UILabel().then {
        $0.font = UIFont.preferredFont(forTextStyle: .subheadline, weight: .medium)
        $0.textColor = .black
        $0.text = "틈새라면 홍대점"
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

    let dateLabel = UILabel().then {
        $0.font = UIFont.preferredFont(forTextStyle: .caption1, weight: .regular)
        $0.textColor = .subText
        $0.text = "10일 전"
    }

    let chatButton = ChatButton()

    let chatLabel = UILabel().then {
        $0.font = UIFont.preferredFont(forTextStyle: .caption1, weight: .regular)
        $0.textColor = .black
        $0.textAlignment = .center
        $0.text = "10"
    }

    let scrapButton = ScrapButton()

    let scrapLabel = UILabel().then {
        $0.font = UIFont.preferredFont(forTextStyle: .caption1, weight: .regular)
        $0.textColor = .black
        $0.textAlignment = .center
        $0.text = "130"
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
        addSubviews(storeNameLabel, categoryLabel, distanceLabel, dateLabel, scrapButton, chatButton, scrapLabel, chatLabel)

        storeNameLabel.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(20)
            $0.top.equalToSuperview().inset(12)
        }

        categoryLabel.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(20)
            $0.top.equalTo(storeNameLabel.snp.bottom).offset(4)
        }

        distanceLabel.snp.makeConstraints {
            $0.leading.equalTo(categoryLabel.snp.trailing).offset(8)
            $0.top.equalTo(storeNameLabel.snp.bottom).offset(4)
        }

        dateLabel.snp.makeConstraints {
            $0.leading.equalTo(distanceLabel.snp.trailing).offset(8)
            $0.top.equalTo(storeNameLabel.snp.bottom).offset(4)
        }

        scrapButton.snp.makeConstraints {
            $0.trailing.equalToSuperview().inset(20)
            $0.top.equalToSuperview().inset(10)
        }

        scrapLabel.snp.makeConstraints {
            $0.leading.equalTo(scrapButton.snp.leading)
            $0.trailing.equalTo(scrapButton.snp.trailing)
            $0.top.equalTo(scrapButton.snp.bottom).offset(4)
        }

        chatButton.snp.makeConstraints {
            $0.trailing.equalTo(scrapButton.snp.leading).offset(-20)
            $0.top.equalToSuperview().inset(10)
        }

        chatLabel.snp.makeConstraints {
            $0.leading.equalTo(chatButton.snp.leading)
            $0.trailing.equalTo(chatButton.snp.trailing)
            $0.top.equalTo(chatButton.snp.bottom).offset(4)
        }
    }
}
