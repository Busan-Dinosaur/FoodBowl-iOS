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
    private var viewModel: NewFeedViewModel

    init(viewModel: NewFeedViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - property
    private let guideLabel = UILabel().then {
        $0.text = "후기를 작성할 가게를 찾아주세요."
        $0.font = UIFont.preferredFont(forTextStyle: .body, weight: .medium)
        $0.textColor = .mainText
    }

    private lazy var searchBarButton = SearchBarButton().then {
        $0.placeholderLabel.text = "가게 검색"
        let action = UIAction { [weak self] _ in
            guard let viewModel = self?.viewModel else { return }
            let searchStoreViewController = SearchStoreViewController(viewModel: viewModel)
            let navigationController = UINavigationController(rootViewController: searchStoreViewController)
            navigationController.modalPresentationStyle = .fullScreen
            searchStoreViewController.delegate = self
            DispatchQueue.main.async {
                self?.present(navigationController, animated: true)
            }
        }
        $0.addAction(action, for: .touchUpInside)
    }

    private lazy var selectedStoreView = SelectedStoreView().then {
        $0.isHidden = true
    }

    // MARK: - life cycle
    override func setupLayout() {
        view.addSubviews(guideLabel, searchBarButton, selectedStoreView)

        guideLabel.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top).inset(20)
            $0.leading.equalToSuperview().inset(BaseSize.horizantalPadding)
        }

        searchBarButton.snp.makeConstraints {
            $0.top.equalTo(guideLabel.snp.bottom).offset(20)
            $0.leading.trailing.equalToSuperview().inset(BaseSize.horizantalPadding)
            $0.height.equalTo(40)
        }

        selectedStoreView.snp.makeConstraints {
            $0.top.equalTo(searchBarButton.snp.bottom).offset(10)
            $0.leading.trailing.equalToSuperview().inset(BaseSize.horizantalPadding)
            $0.height.equalTo(60)
        }
    }
}

extension SetStoreViewController: SearchStoreViewControllerDelegate {
    func setStore(store: Place) {
        searchBarButton.placeholderLabel.text = "가게 재검색"
        selectedStoreView.storeNameLabel.text = store.placeName
        selectedStoreView.storeAdressLabel.text = store.addressName
        selectedStoreView.isHidden = false

        let action = UIAction { [weak self] _ in
            let showWebViewController = ShowWebViewController()
            showWebViewController.title = "가게 정보"
            showWebViewController.url = store.placeURL

            let navigationController = UINavigationController(rootViewController: showWebViewController)
            navigationController.modalPresentationStyle = .fullScreen

            DispatchQueue.main.async {
                self?.present(navigationController, animated: true)
            }
        }
        selectedStoreView.mapButton.addAction(action, for: .touchUpInside)

        Task {
            await viewModel.setStore(store: store)
        }
    }
}
