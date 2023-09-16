//
//  ResultsStoreTableViewController.swift
//  FoodBowl
//
//  Created by COBY_PRO on 2022/12/23.
//

import UIKit

import SnapKit
import Then

final class ResultsStoreTableViewController: BaseViewController {
    // MARK: - property
    lazy var storeInfoTableView = UITableView().then {
        $0.register(StoreSearchTableViewCell.self, forCellReuseIdentifier: StoreSearchTableViewCell.className)
        $0.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 20, right: 0)
        $0.backgroundColor = .clear
    }

    override func setupLayout() {
        view.addSubviews(storeInfoTableView)

        storeInfoTableView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
}
