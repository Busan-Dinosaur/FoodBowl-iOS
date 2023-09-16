//
//  CreateReviewController.swift
//  FoodBowl
//
//  Created by COBY_PRO on 2023/09/16.
//

import UIKit

import SnapKit
import Then

final class CreateReviewController: BaseViewController {
    private var viewModel = NewFeedViewModel()

    private let newFeedGuideLabel = PaddingLabel().then {
        $0.font = .font(.regular, ofSize: 22)
        $0.text = "후기 작성"
        $0.textColor = .mainText
        $0.padding = UIEdgeInsets(top: 0, left: 4, bottom: 0, right: 0)
        $0.frame = CGRect(x: 0, y: 0, width: 150, height: 0)
    }

    private lazy var searchBarButton = SearchBarButton().then {
        $0.placeholderLabel.text = "맛집 검색"
        let action = UIAction { [weak self] _ in
            guard let viewModel = self?.viewModel else { return }
            let setStoreViewController = SetStoreViewController(viewModel: viewModel)
            DispatchQueue.main.async {
                self?.navigationController?.pushViewController(setStoreViewController, animated: true)
            }
        }
        $0.addAction(action, for: .touchUpInside)
    }

    private lazy var selectedStoreView = SelectedStoreView().then {
        $0.isHidden = true
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setStore()
    }

    override func setupLayout() {
        view.addSubviews(searchBarButton, selectedStoreView)
        searchBarButton.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide)
            $0.leading.trailing.equalToSuperview().inset(BaseSize.horizantalPadding)
            $0.height.equalTo(40)
        }

        selectedStoreView.snp.makeConstraints {
            $0.top.equalTo(searchBarButton.snp.bottom).offset(10)
            $0.leading.trailing.equalToSuperview().inset(BaseSize.horizantalPadding)
            $0.height.equalTo(60)
        }
    }

    override func setupNavigationBar() {
        super.setupNavigationBar()
        let newFeedGuideLabel = makeBarButtonItem(with: newFeedGuideLabel)
        navigationItem.leftBarButtonItem = newFeedGuideLabel
    }

    private func tappedCompleteButton() {
        Task {
            await viewModel.createReview()
        }
        dismiss(animated: true, completion: nil)
    }

    private func showAlert(message: String) {
        let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        let cancel = UIAlertAction(title: "닫기", style: .cancel, handler: nil)

        alert.addAction(cancel)

        present(alert, animated: true, completion: nil)
    }

    private func setStore() {
        if let store = viewModel.store {
            searchBarButton.placeholderLabel.text = "맛집 재검색"
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
        }
    }
}
