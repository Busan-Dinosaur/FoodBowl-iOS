//
//  FindResultViewController.swift
//  FoodBowl
//
//  Created by COBY_PRO on 2023/01/18.
//

import UIKit

import SnapKit
import Then

final class FindResultViewController: BaseViewController {
    lazy var searchResultTableView = UITableView().then {
        $0.register(StoreInfoTableViewCell.self, forCellReuseIdentifier: StoreInfoTableViewCell.className)
        $0.register(UserInfoTableViewCell.self, forCellReuseIdentifier: UserInfoTableViewCell.className)
        $0.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 20, right: 0)
        $0.backgroundColor = .mainBackground
    }

    override func setupLayout() {
        view.addSubviews(searchResultTableView)

        searchResultTableView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
}
