//
//  FriendFeedViewController.swift
//  FoodBowl
//
//  Created by COBY_PRO on 2023/07/22.
//

import MessageUI
import UIKit

import SnapKit
import Then

final class FriendFeedViewController: BaseViewController {
    private enum Size {
        static let collectionInset = UIEdgeInsets(
            top: 0,
            left: 0,
            bottom: 20,
            right: 0
        )
    }

    private lazy var isBookmarked = [Bool](repeating: false, count: 10)

    private var refreshControl = UIRefreshControl()

    // MARK: - property
    private let collectionViewFlowLayout = DynamicHeightCollectionViewFlowLayout().then {
        $0.sectionInset = Size.collectionInset
        $0.minimumLineSpacing = 20
        $0.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
    }

    private lazy var listCollectionView = UICollectionView(frame: .zero, collectionViewLayout: collectionViewFlowLayout).then {
        $0.dataSource = self
        $0.delegate = self
        $0.showsVerticalScrollIndicator = false
        $0.register(FeedCollectionViewCell.self, forCellWithReuseIdentifier: FeedCollectionViewCell.className)
        $0.backgroundColor = .mainBackground
    }

    // MARK: - life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupRefreshControl()
    }

    override func setupLayout() {
        view.addSubviews(listCollectionView)

        listCollectionView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }

    private func setupRefreshControl() {
        let action = UIAction { [weak self] _ in
        }
        refreshControl.addAction(action, for: .valueChanged)
        refreshControl.tintColor = .lightGray
        listCollectionView.refreshControl = refreshControl
    }
}

extension FriendFeedViewController {
    // Standard scroll-view delegate
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let contentSize = scrollView.contentSize.height

        if contentSize - scrollView.contentOffset.y <= scrollView.bounds.height {
            didScrollToBottom()
        }
    }

    private func didScrollToBottom() {}
}

// MARK: - UICollectionViewDataSource, UICollectionViewDelegate
extension FriendFeedViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_: UICollectionView, numberOfItemsInSection _: Int) -> Int {
        return 10
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: FeedCollectionViewCell.className,
            for: indexPath
        ) as? FeedCollectionViewCell else {
            return UICollectionViewCell()
        }

        cell.userButtonTapAction = { [weak self] _ in
            let profileViewController = ProfileViewController(isOwn: false)
            self?.navigationController?.pushViewController(profileViewController, animated: true)
        }

        cell.optionButtonTapAction = { [weak self] _ in
            let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)

            let report = UIAlertAction(title: "신고하기", style: .destructive, handler: { _ in
                self?.sendReportMail()
            })
            let cancel = UIAlertAction(title: "취소", style: .cancel, handler: nil)

            alert.addAction(cancel)
            alert.addAction(report)

            self?.present(alert, animated: true, completion: nil)
        }

        cell.followButtonTapAction = { _ in
            cell.userInfoView.followButton.isSelected.toggle()
        }

        cell.storeButtonTapAction = { [weak self] _ in
            let storeDetailViewController = StoreDetailViewController()
            storeDetailViewController.title = "틈새라면"
            self?.navigationController?.pushViewController(storeDetailViewController, animated: true)
        }

        cell.bookmarkButtonTapAction = { [weak self] _ in
            self?.isBookmarked[indexPath.item].toggle()
            cell.storeInfoView.bookmarkButton.isSelected.toggle()
        }
        cell.storeInfoView.bookmarkButton.isSelected = isBookmarked[indexPath.item]

        return cell
    }
}
