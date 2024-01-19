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
        $0.setTitleColor(.mainTextColor, for: .normal)
        $0.titleLabel?.font = UIFont.preferredFont(forTextStyle: .footnote, weight: .medium)
        $0.contentHorizontalAlignment = .left
    }

    let categoryLabel = UILabel().then {
        $0.font = UIFont.preferredFont(forTextStyle: .caption2, weight: .regular)
        $0.textColor = .subTextColor
    }

    let distanceLabel = UILabel().then {
        $0.font = UIFont.preferredFont(forTextStyle: .caption2, weight: .regular)
        $0.textColor = .subTextColor
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
        addSubviews(storeNameButton, categoryLabel, distanceLabel, bookmarkButton)

        storeNameButton.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(14)
            $0.top.equalToSuperview().inset(10)
            $0.height.equalTo(18)
        }

        categoryLabel.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(14)
            $0.top.equalTo(storeNameButton.snp.bottom).offset(2)
        }

        distanceLabel.snp.makeConstraints {
            $0.leading.equalTo(categoryLabel.snp.trailing).offset(8)
            $0.top.equalTo(storeNameButton.snp.bottom).offset(2)
        }

        bookmarkButton.snp.makeConstraints {
            $0.trailing.equalToSuperview().inset(14)
            $0.centerY.equalToSuperview()
        }
    }

    private func configureUI() {
        makeBorderLayer(color: .grey002)
    }

    func configureStore(_ store: StoreByReviewDTO) {
        storeNameButton.setTitle(store.name, for: .normal)
        categoryLabel.text = store.categoryName
        distanceLabel.text = store.distance.prettyDistance
        bookmarkButton.isSelected = store.isBookmarked
    }
}
