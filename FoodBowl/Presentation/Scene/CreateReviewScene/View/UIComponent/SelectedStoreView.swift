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
        $0.textColor = .mainTextColor
    }

    let storeAdressLabel = UILabel().then {
        $0.font = UIFont.preferredFont(forTextStyle: .caption1, weight: .light)
        $0.textColor = .subTextColor
    }

    let mapButton = MapButton()

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
        addSubviews(storeNameLabel, storeAdressLabel, mapButton)

        storeNameLabel.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(14)
            $0.top.equalToSuperview().inset(12)
        }

        storeAdressLabel.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(14)
            $0.bottom.equalToSuperview().inset(12)
        }

        mapButton.snp.makeConstraints {
            $0.trailing.equalToSuperview().inset(14)
            $0.centerY.equalToSuperview()
        }
    }

    private func configureUI() {
        backgroundColor = .clear
        makeBorderLayer(color: .grey002)
    }
}

extension SelectedStoreView {
    func configureStore(_ store: PlaceItemDTO) {
        let action = UIAction { _ in
            let showWebViewController = ShowWebViewController(url: store.placeURL)
            let navigationController = UINavigationController(rootViewController: showWebViewController)
            
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now()) {
                guard let rootVC = (UIApplication.shared.connectedScenes.first as? UIWindowScene)?.windows.first?.rootViewController
                else { return }
                rootVC.present(navigationController, animated: true)
            }
        }
        self.mapButton.addAction(action, for: .touchUpInside)
        self.storeNameLabel.text = store.placeName
        self.storeAdressLabel.text = store.addressName
    }
}
