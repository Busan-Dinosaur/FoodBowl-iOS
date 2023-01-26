//
//  FollowerViewController.swift
//  FoodBowl
//
//  Created by COBY_PRO on 2023/01/19.
//

import UIKit

import SnapKit
import Then

final class FollowerViewController: BaseViewController {
    // MARK: - property

    private lazy var userResultTableView = UITableView().then {
        $0.register(UserResultTableViewCell.self, forCellReuseIdentifier: UserResultTableViewCell.className)
        $0.delegate = self
        $0.dataSource = self
        $0.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 20, right: 0)
    }

    // MARK: - life cycle

    override func render() {
        view.addSubviews(userResultTableView)

        userResultTableView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }

    override func setupNavigationBar() {
        super.setupNavigationBar()
        title = "팔로워"
    }
}

extension FollowerViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_: UITableView, numberOfRowsInSection _: Int) -> Int {
        return 5
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: UserResultTableViewCell.className, for: indexPath) as? UserResultTableViewCell else { return UITableViewCell() }

        cell.selectionStyle = .none

        let action = UIAction { _ in
            cell.followButton.isSelected = !cell.followButton.isSelected
        }
        cell.followButton.addAction(action, for: .touchUpInside)

        return cell
    }

    func tableView(_: UITableView, heightForRowAt _: IndexPath) -> CGFloat {
        return 60
    }

    func tableView(_: UITableView, didSelectRowAt _: IndexPath) {
        print("가게 선택")
    }
}
