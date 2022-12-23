//
//  MessageViewController.swift
//  FoodBowl
//
//  Created by COBY_PRO on 2022/12/23.
//

import UIKit

import SnapKit
import Then

final class MessageViewController: BaseViewController {
    private var recentMessages: [String] = ["", "", "", "", ""]

    // MARK: - property

    private lazy var channelTableView = UITableView().then {
        $0.register(ChannelTableViewCell.self, forCellReuseIdentifier: ChannelTableViewCell.className)
        $0.delegate = self
        $0.dataSource = self
        $0.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }

    // MARK: - life cycle

    override func render() {
        view.addSubviews(channelTableView)

        channelTableView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }

    override func setupNavigationBar() {
        super.setupNavigationBar()

        navigationItem.leftBarButtonItem = nil
        title = "메세지"
    }
}

extension MessageViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_: UITableView, numberOfRowsInSection _: Int) -> Int {
        return 5
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ChannelTableViewCell.className, for: indexPath) as? ChannelTableViewCell else { return UITableViewCell() }

        cell.selectionStyle = .none

        return cell
    }

    func tableView(_: UITableView, heightForRowAt _: IndexPath) -> CGFloat {
        return 70
    }

    func tableView(_: UITableView, didSelectRowAt indexPath: IndexPath) {
        let recentMessage = recentMessages[indexPath.row]
        let messageRoomViewController = MessageRoomViewController()
        navigationController?.pushViewController(messageRoomViewController, animated: true)
    }
}
