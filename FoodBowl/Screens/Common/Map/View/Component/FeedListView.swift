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

    var reviews: [Review] = [] {
        didSet {
            DispatchQueue.main.async {
                self.listCollectionView.reloadData()
                self.refreshControl.endRefreshing()
            }
        }
    }

    private var loadData: () -> Void
    private var reloadData: () -> Void
    private var presentBlameVC: (Int, String) -> Void

    private var viewModel = BaseViewModel()

    private var refreshControl = UIRefreshControl()

    // MARK: - init
    init(loadData: @escaping (() -> Void), reloadData: @escaping (() -> Void), presentBlameVC: @escaping (Int, String) -> Void) {
        self.loadData = loadData
        self.reloadData = reloadData
        self.presentBlameVC = presentBlameVC
        super.init(frame: .zero)
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

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
        reloadData()
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

        cell.setupData(reviews[indexPath.item])

        cell.userButtonTapAction = { [weak self] _ in
            let profileViewController = ProfileViewController(memberId: member.id)

            DispatchQueue.main.async { [weak self] in
                self?.parentViewController?.navigationController?.pushViewController(profileViewController, animated: true)
            }
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

                let del = UIAlertAction(title: "삭제", style: .destructive, handler: { _ in
                    guard let self = self else { return }
                    self.parentViewController?.showDeleteAlert {
                        Task {
                            if await self.viewModel.removeReview(id: review.id) {
                                self.loadData()
                            }
                        }
                    }
                })
                alert.addAction(del)
            } else {
                let report = UIAlertAction(title: "신고", style: .destructive, handler: { _ in
                    self?.presentBlameVC(review.id, "REVIEW")
                })
                alert.addAction(report)
            }

            let cancel = UIAlertAction(title: "취소", style: .cancel, handler: nil)
            alert.addAction(cancel)

            DispatchQueue.main.async { [weak self] in
                self?.parentViewController?.present(alert, animated: true, completion: nil)
            }
        }

        cell.storeButtonTapAction = { [weak self] _ in
            let storeDetailViewController = StoreDetailViewController(storeId: store.id)
            storeDetailViewController.title = store.name

            DispatchQueue.main.async { [weak self] in
                self?.parentViewController?.navigationController?.pushViewController(storeDetailViewController, animated: true)
            }
        }

        cell.bookmarkButtonTapAction = { [weak self] _ in
            guard let self = self else { return }
            Task {
                if cell.storeInfoView.bookmarkButton.isSelected {
                    if await self.viewModel.removeBookmark(storeId: store.id) {
                        cell.storeInfoView.bookmarkButton.isSelected.toggle()
                        self.loadData()
                    }
                } else {
                    if await self.viewModel.createBookmark(storeId: store.id) {
                        cell.storeInfoView.bookmarkButton.isSelected.toggle()
                        self.loadData()
                    }
                }
            }
        }

        return cell
    }
}
