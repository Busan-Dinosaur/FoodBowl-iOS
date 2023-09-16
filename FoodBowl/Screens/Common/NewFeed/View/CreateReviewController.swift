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
    private var stores = [Place]()

    private var viewModel = CreateReviewViewModel()

    private let newFeedGuideLabel = PaddingLabel().then {
        $0.font = .font(.regular, ofSize: 22)
        $0.text = "후기 작성"
        $0.textColor = .mainText
        $0.padding = UIEdgeInsets(top: 0, left: 4, bottom: 0, right: 0)
        $0.frame = CGRect(x: 0, y: 0, width: 150, height: 0)
    }

    private lazy var resultsStoreTableViewController = ResultsStoreTableViewController().then {
        $0.storeInfoTableView.delegate = self
        $0.storeInfoTableView.dataSource = self
    }

    private lazy var searchController =
        UISearchController(searchResultsController: resultsStoreTableViewController).then {
            $0.searchBar.placeholder = "맛집 검색"
            $0.searchResultsUpdater = self
            $0.searchBar.setValue("취소", forKey: "cancelButtonText")
            $0.searchBar.tintColor = .mainPink
        }

    private lazy var selectedStoreView = SelectedStoreView().then {
        $0.isHidden = false
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }

    override func setupLayout() {
        view.addSubviews(selectedStoreView)
        selectedStoreView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide)
            $0.leading.trailing.equalToSuperview().inset(BaseSize.horizantalPadding)
            $0.height.equalTo(60)
        }
    }

    override func setupNavigationBar() {
        super.setupNavigationBar()
        let newFeedGuideLabel = makeBarButtonItem(with: newFeedGuideLabel)
        let closeButton = makeBarButtonItem(with: closeButton)
        navigationItem.leftBarButtonItem = newFeedGuideLabel
        navigationItem.rightBarButtonItem = closeButton
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
    }

    private func showAlert(message: String) {
        let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        let cancel = UIAlertAction(title: "닫기", style: .cancel, handler: nil)

        alert.addAction(cancel)

        present(alert, animated: true, completion: nil)
    }

    private func tappedCompleteButton() {
        Task {
            await viewModel.createReview()
        }
        dismiss(animated: true, completion: nil)
    }
}

extension CreateReviewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        guard let text = searchController.searchBar.text?.lowercased() else { return }
        searchStores(keyword: text)
    }

    private func searchStores(keyword: String) {
        Task {
            stores = await viewModel.searchStores(keyword: keyword)
            resultsStoreTableViewController.storeInfoTableView.reloadData()
        }
    }
}

extension CreateReviewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_: UITableView, numberOfRowsInSection _: Int) -> Int {
        return stores.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView
            .dequeueReusableCell(withIdentifier: StoreSearchTableViewCell.className, for: indexPath) as? StoreSearchTableViewCell
        else { return UITableViewCell() }

        cell.selectionStyle = .none
        cell.storeNameLabel.text = stores[indexPath.item].placeName
        cell.storeAdressLabel.text = stores[indexPath.item].addressName
        cell.storeDistanceLabel.text = stores[indexPath.item].distance.prettyDistance

        return cell
    }

    func tableView(_: UITableView, heightForRowAt _: IndexPath) -> CGFloat {
        return 60
    }

    func tableView(_: UITableView, didSelectRowAt indexPath: IndexPath) {
        setStore(store: stores[indexPath.item])
    }

    private func setStore(store: Place) {
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
