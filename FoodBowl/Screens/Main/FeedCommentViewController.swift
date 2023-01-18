//
//  FeedCommentViewController.swift
//  FoodBowl
//
//  Created by COBY_PRO on 2023/01/18.
//

import UIKit

import SnapKit
import Then

final class FeedCommentViewController: BaseViewController {
    // MARK: - property

    private lazy var commentTableView = UITableView().then {
        $0.register(FeedCommentTableViewCell.self, forCellReuseIdentifier: FeedCommentTableViewCell.className)
        $0.delegate = self
        $0.dataSource = self
        $0.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 20, right: 0)
        $0.rowHeight = UITableView.automaticDimension
        $0.estimatedRowHeight = 60
    }

    // MARK: - life cycle

    override func render() {
        view.addSubviews(commentTableView)

        commentTableView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }

    override func setupNavigationBar() {
        super.setupNavigationBar()
        title = "댓글"
    }
}

extension FeedCommentViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_: UITableView, numberOfRowsInSection _: Int) -> Int {
        return 10
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: FeedCommentTableViewCell.className, for: indexPath) as? FeedCommentTableViewCell else { return UITableViewCell() }

        cell.selectionStyle = .none

        return cell
    }

    func tableView(_: UITableView, estimatedHeightForRowAt _: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}
