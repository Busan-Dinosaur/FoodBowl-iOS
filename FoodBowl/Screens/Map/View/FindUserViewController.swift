//
//  FindUserViewController.swift
//  FoodBowl
//
//  Created by COBY_PRO on 2023/07/25.
//

import UIKit

import SnapKit
import Then

final class FindUserViewController: BaseViewController {
    private lazy var searchBar = UISearchBar().then {
        $0.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width - 80, height: 0)
        $0.placeholder = "유저의 이름을 검색해주세요."
        $0.delegate = self
    }

    private lazy var userResultTableView = UITableView().then {
        $0.register(UserInfoTableViewCell.self, forCellReuseIdentifier: UserInfoTableViewCell.className)
        $0.delegate = self
        $0.dataSource = self
        $0.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 20, right: 0)
        $0.backgroundColor = .mainBackground
    }

    override func setupLayout() {
        view.addSubviews(userResultTableView)

        userResultTableView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }

    override func setupNavigationBar() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: searchBar)
    }
}

extension FindUserViewController: UISearchBarDelegate {
    private func dissmissKeyboard() {
        searchBar.resignFirstResponder()
    }

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        dissmissKeyboard()
        guard let searchTerm = searchBar.text, searchTerm.isEmpty == false else { return }
        print(searchTerm)
    }
}

extension FindUserViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_: UITableView, numberOfRowsInSection _: Int) -> Int {
        return 5
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView
            .dequeueReusableCell(withIdentifier: UserInfoTableViewCell.className, for: indexPath) as? UserInfoTableViewCell
        else { return UITableViewCell() }

        cell.selectionStyle = .none

        cell.userButtonTapAction = { [weak self] _ in
            let profileViewController = ProfileViewController(isOwn: false)
            self?.navigationController?.pushViewController(profileViewController, animated: true)
        }

        cell.followButtonTapAction = { [weak self] _ in
            cell.followButton.isSelected.toggle()
        }

        return cell
    }

    func tableView(_: UITableView, heightForRowAt _: IndexPath) -> CGFloat {
        return 64
    }
}
