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

    let storeDetailButton = UIButton().then {
        $0.setTitleColor(.mainTextColor, for: .normal)
        $0.titleLabel?.font = UIFont.preferredFont(forTextStyle: .caption2, weight: .light)
        $0.contentHorizontalAlignment = .left
    }
    
    let storeAddressButton = UIButton().then {
        $0.setTitleColor(.subTextColor, for: .normal)
        $0.titleLabel?.font = UIFont.preferredFont(forTextStyle: .caption2, weight: .regular)
        $0.contentHorizontalAlignment = .left
    }

    let bookmarkButton = BookmarkButton()

    // MARK: - init
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupLayout()
        self.configureUI()
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupLayout() {
        self.addSubviews(
            self.storeNameButton,
            self.storeDetailButton,
            self.storeAddressButton,
            self.bookmarkButton
        )

        self.storeNameButton.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(14)
            $0.top.equalToSuperview().inset(10)
            $0.height.equalTo(18)
        }

        self.storeDetailButton.snp.makeConstraints {
            $0.leading.equalTo(self.storeNameButton.snp.trailing).offset(8)
            $0.centerY.equalTo(self.storeNameButton)
            $0.height.equalTo(13)
        }
        
        self.storeAddressButton.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(14)
            $0.top.equalTo(self.storeNameButton.snp.bottom).offset(2)
            $0.height.equalTo(13)
        }

        self.bookmarkButton.snp.makeConstraints {
            $0.trailing.equalToSuperview().inset(14)
            $0.centerY.equalToSuperview()
        }
    }

    private func configureUI() {
        self.makeBorderLayer(color: .grey002)
    }

    func configureStore(_ store: StoreByReviewDTO) {
        self.storeNameButton.setTitle(store.name, for: .normal)
        self.storeDetailButton.setTitle("\(store.categoryName), \(store.distance.prettyDistance)", for: .normal)
        self.storeAddressButton.setTitle(store.addressName, for: .normal)
        self.bookmarkButton.isSelected = store.isBookmarked
    }
}
