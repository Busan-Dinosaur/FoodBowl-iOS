//
//  FeedListView.swift
//  FoodBowl
//
//  Created by COBY_PRO on 2023/07/22.
//

import UIKit

import SnapKit
import Then

final class FeedListView: ModalView {
    private enum Size {
        static let collectionInset = UIEdgeInsets(
            top: 10,
            left: 0,
            bottom: 10,
            right: 0
        )
    }

    private var refreshControl = UIRefreshControl()

    private lazy var isBookmarked = [Bool](repeating: false, count: 10)

    override func setupProperty() {
        collectionViewFlowLayout = DynamicHeightCollectionViewFlowLayout().then {
            $0.sectionInset = Size.collectionInset
            $0.minimumLineSpacing = 20
            $0.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
        }

        listCollectionView = UICollectionView(frame: .zero, collectionViewLayout: collectionViewFlowLayout).then {
            $0.dataSource = self
            $0.delegate = self
            $0.showsVerticalScrollIndicator = false
            $0.register(FeedCollectionViewCell.self, forCellWithReuseIdentifier: FeedCollectionViewCell.className)
            $0.backgroundColor = .mainBackgroundColor
        }
    }

    override func setupRefreshControl() {
        let action = UIAction { [weak self] _ in
            self?.loadData()
        }
        refreshControl.addAction(action, for: .valueChanged)
        refreshControl.tintColor = .grey002
        listCollectionView.refreshControl = refreshControl
    }

    func loadData() {}
}

extension FeedListView {
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
extension FeedListView: UICollectionViewDataSource, UICollectionViewDelegate {
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
            self?.parentViewController?.navigationController?.pushViewController(profileViewController, animated: true)
        }

        cell.optionButtonTapAction = { [weak self] _ in
            let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)

            let edit = UIAlertAction(title: "수정", style: .default, handler: { _ in
                let viewModel = UpdateReviewViewModel()
                let updateReviewViewController = UpdateReviewViewController(viewModel: viewModel)
                let navigationController = UINavigationController(rootViewController: updateReviewViewController)
                DispatchQueue.main.async {
                    self?.parentViewController?.present(navigationController, animated: true)
                }
            })

            let report = UIAlertAction(title: "신고", style: .destructive, handler: { _ in
                self?.parentViewController?.sendReportMail()
            })
            let cancel = UIAlertAction(title: "취소", style: .cancel, handler: nil)

            alert.addAction(edit)
            alert.addAction(cancel)
            alert.addAction(report)

            self?.parentViewController?.present(alert, animated: true, completion: nil)
        }

        cell.followButtonTapAction = { _ in
            cell.userInfoView.followButton.isSelected.toggle()
        }

        cell.storeButtonTapAction = { [weak self] _ in
            let storeDetailViewController = StoreDetailViewController()
            storeDetailViewController.title = "틈새라면"
            self?.parentViewController?.navigationController?.pushViewController(storeDetailViewController, animated: true)
        }

        cell.bookmarkButtonTapAction = { [weak self] _ in
            self?.isBookmarked[indexPath.item].toggle()
            cell.storeInfoView.bookmarkButton.isSelected.toggle()
        }
        cell.storeInfoView.bookmarkButton.isSelected = isBookmarked[indexPath.item]

        return cell
    }
}
