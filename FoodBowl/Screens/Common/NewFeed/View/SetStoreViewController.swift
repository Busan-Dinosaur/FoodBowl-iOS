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

    private var stores = [Place]()

    // MARK: - property
    private lazy var searchController = UISearchController(searchResultsController: nil).then {
        $0.searchBar.placeholder = "검색"
        $0.searchResultsUpdater = self
        $0.obscuresBackgroundDuringPresentation = false
    }

    private lazy var cancelButton = UIButton().then {
        $0.setTitle("취소", for: .normal)
        $0.setTitleColor(.mainPink, for: .normal)
        $0.titleLabel?.font = UIFont.preferredFont(forTextStyle: .headline, weight: .regular)
        let buttonAction = UIAction { [weak self] _ in
            self?.dismiss(animated: true, completion: nil)
        }
        $0.addAction(buttonAction, for: .touchUpInside)
    }

    private lazy var storeInfoTableView = UITableView().then {
        $0.register(StoreSearchTableViewCell.self, forCellReuseIdentifier: StoreSearchTableViewCell.className)
        $0.delegate = self
        $0.dataSource = self
        $0.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 20, right: 0)
        $0.backgroundColor = .clear
    }

    // MARK: - life cycle

    override func setupLayout() {
        view.addSubviews(storeInfoTableView)
        storeInfoTableView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide)
            $0.leading.trailing.bottom.equalToSuperview()
        }
    }

    override func setupNavigationBar() {
        super.setupNavigationBar()
        navigationItem.searchController = searchController
        title = "맛집 검색"
    }

    private func searchStores(keyword: String) {
        Task {
            stores = await viewModel.searchStores(keyword: keyword)
            storeInfoTableView.reloadData()
        }
    }

    private func setStore(store: Place) {
        Task {
            await viewModel.setStore(store: store)
            navigationController?.popViewController(animated: true)
        }
    }
}

extension SetStoreViewController: UITableViewDataSource, UITableViewDelegate {
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
}

extension SetStoreViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        guard let text = searchController.searchBar.text?.lowercased() else { return }
        searchStores(keyword: text)
    }
}
