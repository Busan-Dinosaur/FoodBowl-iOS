//
//  SetStoreViewController.swift
//  FoodBowl
//
//  Created by COBY_PRO on 2022/12/23.
//

import UIKit

import SnapKit
import Then

final class SetStoreViewController: BaseViewController {
    var delegate: SetStoreViewControllerDelegate?
    var selectedStore: Place?

    // MARK: - property

    private let guideLabel = UILabel().then {
        $0.text = "게시물을 작성할 가게를 찾아보세요."
        $0.font = UIFont.preferredFont(forTextStyle: .title3, weight: .medium)
    }

    lazy var searchBarButton = SearchBarButton().then {
        $0.label.text = "가게 검색"
        let action = UIAction { [weak self] _ in
            let searchStoreViewController = SearchStoreViewController()
            let navigationController = UINavigationController(rootViewController: searchStoreViewController)
            navigationController.modalPresentationStyle = .fullScreen
            searchStoreViewController.delegate = self
            DispatchQueue.main.async {
                self?.present(navigationController, animated: true)
            }
        }
        $0.addAction(action, for: .touchUpInside)
    }

    lazy var selectedStoreView = SelectedStoreView().then {
        $0.isHidden = true
    }

    // MARK: - life cycle

    override func render() {
        view.addSubviews(guideLabel, searchBarButton, selectedStoreView)

        guideLabel.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top).inset(20)
            $0.leading.equalToSuperview().inset(20)
        }

        searchBarButton.snp.makeConstraints {
            $0.top.equalTo(guideLabel.snp.bottom).offset(20)
            $0.leading.trailing.equalToSuperview().inset(20)
            $0.height.equalTo(50)
        }

        selectedStoreView.snp.makeConstraints {
            $0.top.equalTo(searchBarButton.snp.bottom).offset(10)
            $0.leading.trailing.equalToSuperview().inset(20)
            $0.height.equalTo(60)
        }
    }
}

protocol SearchStoreViewControllerDelegate: AnyObject {
    func setStore(store: Place)
}

extension SetStoreViewController: SearchStoreViewControllerDelegate {
    func setStore(store: Place) {
        selectedStore = store
        searchBarButton.label.text = "가게 재검색"
        selectedStoreView.storeNameLabel.text = selectedStore?.placeName
        selectedStoreView.storeAdressLabel.text = selectedStore?.addressName
        selectedStoreView.isHidden = false
        let action = UIAction { [weak self] _ in
            let showWebViewController = ShowWebViewController()
            showWebViewController.title = "가게 정보"
            showWebViewController.url = self?.selectedStore?.placeURL ?? ""
            let navigationController = UINavigationController(rootViewController: showWebViewController)
            navigationController.modalPresentationStyle = .fullScreen
            DispatchQueue.main.async {
                self?.present(navigationController, animated: true)
            }
        }
        selectedStoreView.mapButton.addAction(action, for: .touchUpInside)

        delegate?.setStore(store: selectedStore)
    }
}

protocol SetStoreViewControllerDelegate: AnyObject {
    func setStore(store: Place?)
}
