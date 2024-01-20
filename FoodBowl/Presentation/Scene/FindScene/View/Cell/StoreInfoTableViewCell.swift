//
//  StoreInfoTableViewCell.swift
//  FoodBowl
//
//  Created by COBY_PRO on 2023/01/18.
//

import UIKit

import SnapKit
import Then

final class StoreInfoTableViewCell: UITableViewCell, BaseViewType {
    
    // MARK: - ui component
    
    private let storeNameLabel = UILabel().then {
        $0.font = UIFont.preferredFont(forTextStyle: .subheadline, weight: .medium)
        $0.textColor = .mainTextColor
    }
    private let storeAddressLabel = UILabel().then {
        $0.font = UIFont.preferredFont(forTextStyle: .caption1, weight: .light)
        $0.textColor = .subTextColor
    }
    private let storeDistanceLabel = UILabel().then {
        $0.font = UIFont.preferredFont(forTextStyle: .caption1, weight: .light)
        $0.textColor = .mainTextColor
    }
    
    // MARK: - init
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.baseInit()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setupLayout() {
        contentView.addSubviews(storeNameLabel, storeAddressLabel, storeDistanceLabel)

        storeNameLabel.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(SizeLiteral.horizantalPadding)
            $0.top.equalToSuperview().inset(15)
        }

        storeAddressLabel.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(SizeLiteral.horizantalPadding)
            $0.top.equalTo(storeNameLabel.snp.bottom).offset(2)
        }

        storeDistanceLabel.snp.makeConstraints {
            $0.trailing.equalToSuperview().inset(SizeLiteral.horizantalPadding)
            $0.top.equalTo(storeNameLabel.snp.bottom).offset(2)
        }
    }

    func configureUI() {
        self.backgroundColor = .mainBackgroundColor
    }
}

// MARK: - Public - func
extension StoreInfoTableViewCell {
    func configureCell(_ store: Store) {
        storeNameLabel.text = store.name
        storeAddressLabel.text = store.address
        storeDistanceLabel.text = store.distance
        
//        storeAddressLabel.text = "\(store.reviewCount)명이 후기를 남겼어요."
    }
}
