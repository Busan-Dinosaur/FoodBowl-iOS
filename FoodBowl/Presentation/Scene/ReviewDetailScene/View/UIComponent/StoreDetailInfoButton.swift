//
//  StoreDetailInfoButton.swift
//  FoodBowl
//
//  Created by Coby on 1/24/24.
//

import UIKit

import SnapKit
import Then

final class StoreDetailInfoButton: UIButton, BaseViewType {
    
    // MARK: - ui component
    
    private let mapButton = MapButton()
    private let storeNameLabel = UILabel().then {
        $0.font = UIFont.preferredFont(forTextStyle: .subheadline, weight: .medium)
        $0.textColor = .mainTextColor
    }
    private let storeCategoryLabel = UILabel().then {
        $0.font = UIFont.preferredFont(forTextStyle: .footnote, weight: .light)
        $0.textColor = .mainTextColor
    }
    private let storeAddressLabel = UILabel().then {
        $0.font = UIFont.preferredFont(forTextStyle: .footnote, weight: .light)
        $0.textColor = .subTextColor
    }
    let bookmarkButton = BookmarkButton()
    private let borderLineView = UIView().then {
        $0.backgroundColor = .grey002.withAlphaComponent(0.5)
    }

    // MARK: - init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.baseInit()
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setupLayout() {
        self.addSubviews(
            self.mapButton,
            self.storeNameLabel,
            self.storeCategoryLabel,
            self.storeAddressLabel,
            self.bookmarkButton,
            self.borderLineView
        )

        self.mapButton.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(10)
            $0.centerY.equalToSuperview()
            $0.width.height.equalTo(60)
        }

        self.storeNameLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(12)
            $0.leading.equalTo(mapButton.snp.trailing)
            $0.width.lessThanOrEqualTo(SizeLiteral.fullWidth - 140)
        }

        self.storeCategoryLabel.snp.makeConstraints {
            $0.leading.equalTo(self.storeNameLabel.snp.trailing).offset(8)
            $0.centerY.equalTo(self.storeNameLabel)
        }

        self.storeAddressLabel.snp.makeConstraints {
            $0.top.equalTo(self.storeNameLabel.snp.bottom).offset(2)
            $0.leading.equalTo(self.mapButton.snp.trailing)
            $0.width.lessThanOrEqualTo(SizeLiteral.fullWidth - 100)
        }

        self.bookmarkButton.snp.makeConstraints {
            $0.trailing.equalToSuperview()
            $0.centerY.equalToSuperview()
            $0.width.height.equalTo(50)
        }
        
        self.borderLineView.snp.makeConstraints {
            $0.leading.trailing.bottom.equalToSuperview()
            $0.height.equalTo(1)
        }
    }
    
    func configureUI() {
        self.backgroundColor = .mainBackgroundColor
    }
}

// MARK: - Public - func
extension StoreDetailInfoButton {
    func configureStore(_ store: Store) {
        self.storeNameLabel.text = store.name
        self.storeCategoryLabel.text = store.category
        self.storeAddressLabel.text = "\(store.address), \(store.distance)"
        self.bookmarkButton.isSelected = store.isBookmark
        
        let action = UIAction { _ in
            let showWebViewController = ShowWebViewController(url: store.url)
            let navigationController = UINavigationController(rootViewController: showWebViewController)
            
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now()) {
                guard let rootVC = (UIApplication.shared.connectedScenes.first as? UIWindowScene)?.windows.first?.rootViewController
                else { return }
                rootVC.present(navigationController, animated: true)
            }
        }
        self.mapButton.addAction(action, for: .touchUpInside)
    }
}
