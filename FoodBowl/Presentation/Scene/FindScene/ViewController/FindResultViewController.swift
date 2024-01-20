//
//  FindResultViewController.swift
//  FoodBowl
//
//  Created by COBY_PRO on 2023/01/18.
//

import UIKit

import SnapKit
import Then

final class FindResultViewController: UIViewController {
    
    // MARK: - init
    
    deinit {
        print("\(#file) is dead")
    }
    
    // MARK: - life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupLayout()
        self.configureUI()
    }
    
    lazy var listTableView = UITableView().then {
        $0.register(StoreInfoTableViewCell.self, forCellReuseIdentifier: StoreInfoTableViewCell.className)
        $0.register(UserInfoTableViewCell.self, forCellReuseIdentifier: UserInfoTableViewCell.className)
        $0.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 20, right: 0)
        $0.backgroundColor = .mainBackgroundColor
    }

    private func setupLayout() {
        self.view.addSubviews(self.listTableView)

        self.listTableView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    private func configureUI() {
        self.view.backgroundColor = .mainBackgroundColor
    }
}
