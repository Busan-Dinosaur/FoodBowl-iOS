//
//  SearchStoreResultViewController.swift
//  FoodBowl
//
//  Created by COBY_PRO on 2023/01/18.
//

import UIKit

import SnapKit
import Then

final class SearchStoreResultViewController: BaseViewController {
    private var stores = [Place]()

    // MARK: - property

    private lazy var storeResultTableView = UITableView().then {
        $0.register(StoreResultTableViewCell.self, forCellReuseIdentifier: StoreResultTableViewCell.className)
        $0.delegate = self
        $0.dataSource = self
        $0.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 20, right: 0)
    }

    // MARK: - life cycle

    override func render() {
        view.addSubviews(storeResultTableView)

        storeResultTableView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }

    override func setupNavigationBar() {
        navigationController?.isNavigationBarHidden = true
    }
}

extension SearchStoreResultViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_: UITableView, numberOfRowsInSection _: Int) -> Int {
        return 5
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: StoreResultTableViewCell.className, for: indexPath) as? StoreResultTableViewCell else { return UITableViewCell() }

        cell.selectionStyle = .none
        cell.storeNameLabel.text = "가게이름"
        cell.storeFeedLabel.text = "100명이 후기를 남겼습니다."
        cell.storeDistanceLabel.text = "10km"

        return cell
    }

    func tableView(_: UITableView, heightForRowAt _: IndexPath) -> CGFloat {
        return 60
    }

    func tableView(_: UITableView, didSelectRowAt _: IndexPath) {
        print("가게 선택")
    }
}
