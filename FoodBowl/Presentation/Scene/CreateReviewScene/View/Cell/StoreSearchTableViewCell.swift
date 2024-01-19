//
//  StoreSearchTableViewCell.swift
//  FoodBowl
//
//  Created by Coby Kim on 2023/01/13.
//

import UIKit

import SnapKit
import Then

final class StoreSearchTableViewCell: UITableViewCell, BaseViewType {
    
    // MARK: - ui component

    let storeNameLabel = UILabel().then {
        $0.font = UIFont.preferredFont(forTextStyle: .subheadline, weight: .medium)
        $0.textColor = .mainTextColor
    }
    let storeAdressLabel = UILabel().then {
        $0.font = UIFont.preferredFont(forTextStyle: .caption1, weight: .light)
        $0.textColor = .subTextColor
    }
    let storeDistanceLabel = UILabel().then {
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
        self.contentView.addSubviews(self.storeNameLabel, self.storeAdressLabel, self.storeDistanceLabel)

        self.storeNameLabel.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(SizeLiteral.horizantalPadding)
            $0.top.equalToSuperview().inset(12)
        }

        self.storeAdressLabel.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(SizeLiteral.horizantalPadding)
            $0.bottom.equalToSuperview().inset(12)
        }

        self.storeDistanceLabel.snp.makeConstraints {
            $0.trailing.equalToSuperview().inset(SizeLiteral.horizantalPadding)
            $0.bottom.equalToSuperview().inset(12)
        }
    }

    func configureUI() {
        self.backgroundColor = .mainBackgroundColor
    }
}
