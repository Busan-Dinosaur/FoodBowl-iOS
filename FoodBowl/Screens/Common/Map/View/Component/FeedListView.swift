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

    var reviews = [Review]()

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

    func loadData() {
        print("새로고침중")
    }
}

extension FeedListView {
    // Standard scroll-view delegate
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let contentSize = scrollView.contentSize.height

        if contentSize - scrollView.contentOffset.y <= scrollView.bounds.height {
            didScrollToBottom()
        }
    }

    private func didScrollToBottom() {
        print("바닥")
    }
}

// MARK: - UICollectionViewDataSource, UICollectionViewDelegate
extension FeedListView: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_: UICollectionView, numberOfItemsInSection _: Int) -> Int {
        return reviews.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: FeedCollectionViewCell.className,
            for: indexPath
        ) as? FeedCollectionViewCell else {
            return UICollectionViewCell()
        }

        let member = reviews[indexPath.item].writer
        let review = reviews[indexPath.item].review
        let store = reviews[indexPath.item].store
        let isOwn = UserDefaultsManager.currentUser?.id ?? 0 == member.id

        cell.userInfoView.setupData(member)
        cell.setupData(review)
        cell.storeInfoView.setupData(store)

        cell.userButtonTapAction = { [weak self] _ in
            let profileViewController = ProfileViewController(isOwn: false, memberId: member.id)
            self?.parentViewController?.navigationController?.pushViewController(profileViewController, animated: true)
        }

        cell.optionButtonTapAction = { [weak self] _ in
            let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)

            if isOwn {
                let edit = UIAlertAction(title: "수정", style: .default, handler: { _ in
                    let viewModel = UpdateReviewViewModel(reviewContent: review.content, images: review.imagePaths)
                    let updateReviewViewController = UpdateReviewViewController(viewModel: viewModel)
                    let navigationController = UINavigationController(rootViewController: updateReviewViewController)
                    navigationController.modalPresentationStyle = .fullScreen
                    DispatchQueue.main.async {
                        self?.parentViewController?.present(navigationController, animated: true)
                    }
                })
                alert.addAction(edit)
            } else {
                let report = UIAlertAction(title: "신고", style: .destructive, handler: { _ in
                    self?.parentViewController?.presentBlameViewController()
                })
                alert.addAction(report)
            }

            let cancel = UIAlertAction(title: "취소", style: .cancel, handler: nil)
            alert.addAction(cancel)

            self?.parentViewController?.present(alert, animated: true, completion: nil)
        }

        cell.followButtonTapAction = { _ in
            cell.userInfoView.followButton.isSelected.toggle()
        }

        cell.storeButtonTapAction = { [weak self] _ in
            let storeDetailViewController = StoreDetailViewController()
            storeDetailViewController.title = store.name
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
