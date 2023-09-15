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
    var delegate: FindUserViewControllerDelegate?

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

        cell.followButtonTapAction = { [weak self] _ in
            cell.followButton.isSelected.toggle()
        }

        return cell
    }

    func tableView(_: UITableView, heightForRowAt _: IndexPath) -> CGFloat {
        return 64
    }

    func tableView(_: UITableView, didSelectRowAt _: IndexPath) {
        let profileViewController = ProfileViewController(isOwn: false)
        profileViewController.title = "초코비"
        delegate?.setUser(profileViewController: profileViewController)
    }
}

protocol FindUserViewControllerDelegate: AnyObject {
    func setUser(profileViewController: ProfileViewController)
}
