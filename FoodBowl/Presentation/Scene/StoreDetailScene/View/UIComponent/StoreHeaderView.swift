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
        self.setupLayout()
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupLayout() {
        self.addSubviews(
            self.mapButton,
            self.storeNameLabel,
            self.storeCategoryLabel,
            self.storeAddressLabel,
            self.bookmarkButton,
            self.borderLineView
        )

        self.mapButton.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.leading.equalToSuperview().inset(SizeLiteral.horizantalPadding)
        }

        self.storeNameLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(2)
            $0.leading.equalTo(mapButton.snp.trailing).offset(12)
        }

        self.storeCategoryLabel.snp.makeConstraints {
            $0.centerY.equalTo(self.storeNameLabel)
            $0.leading.equalTo(self.storeNameLabel.snp.trailing).offset(8)
        }

        self.storeAddressLabel.snp.makeConstraints {
            $0.top.equalTo(self.storeNameLabel.snp.bottom).offset(2)
            $0.leading.equalTo(self.mapButton.snp.trailing).offset(12)
        }

        self.bookmarkButton.snp.makeConstraints {
            $0.top.equalToSuperview().inset(10)
            $0.trailing.equalToSuperview().inset(SizeLiteral.horizantalPadding)
        }

        self.borderLineView.snp.makeConstraints {
            $0.leading.trailing.bottom.equalToSuperview()
            $0.height.equalTo(1)
        }
    }
}

// MARK: - Public - func
extension StoreHeaderView {
    func configureHeader(_ store: Store) {
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
