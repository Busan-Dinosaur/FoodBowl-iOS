//
//  SearchStoreViewController.swift
//  FoodBowl
//
//  Created by COBY_PRO on 2023/09/16.
//

import UIKit

import SnapKit
import Then

final class SearchStoreViewController: BaseViewController {
    private var viewModel: CreateReviewViewModel

    init(viewModel: CreateReviewViewModel) {
        self.viewModel = viewModel
        super.init()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private var stores = [Place]()

    // MARK: - property
    private lazy var searchBar = UISearchBar().then {
        $0.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width - 80, height: 0)
        $0.placeholder = "검색"
        $0.delegate = self
    }

    private lazy var cancelButton = UIButton().then {
        $0.setTitle("취소", for: .normal)
        $0.setTitleColor(.mainPink, for: .normal)
        $0.titleLabel?.font = UIFont.preferredFont(forTextStyle: .headline, weight: .regular)
        let action = UIAction { [weak self] _ in
            self?.navigationController?.popViewController(animated: true)
        }
        $0.addAction(action, for: .touchUpInside)
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
            $0.edges.equalToSuperview()
        }
    }

    override func configureUI() {
        super.configureUI()

        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.5) {
            self.searchBar.becomeFirstResponder()
        }
    }

    override func setupNavigationBar() {
        let cancelButton = makeBarButtonItem(with: cancelButton)
        navigationItem.rightBarButtonItem = cancelButton
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: searchBar)
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

extension SearchStoreViewController: UITableViewDataSource, UITableViewDelegate {
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

extension SearchStoreViewController: UISearchBarDelegate {
    private func dissmissKeyboard() {
        searchBar.resignFirstResponder()
    }

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        dissmissKeyboard()
    }

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        searchStores(keyword: searchText)
    }
}
