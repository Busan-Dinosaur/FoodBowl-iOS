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

    var reviews: [Review] = []

    private let viewModel = BaseViewModel()

    var loadReviews: () async -> [Review]
    var reloadReviews: () async -> [Review]
    var presentBlameVC: (Int, String) -> Void

    private let refreshControl = UIRefreshControl()
    private var isLoadingData = false

    // MARK: - init
    
    init(
        loadReviews: @escaping (() async -> [Review]),
        reloadReviews: @escaping (() async -> [Review]),
        presentBlameVC: @escaping (Int, String) -> Void
    ) {
        self.loadReviews = loadReviews
        self.reloadReviews = reloadReviews
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
            self?.setupLoadReviews()
        }
        refreshControl.addAction(action, for: .valueChanged)
        refreshControl.tintColor = .grey002
        listCollectionView.refreshControl = refreshControl
    }

    private func setupLoadReviews() {
        Task {
            DispatchQueue.main.async {
                self.listCollectionView.reloadData()
                self.refreshControl.endRefreshing()
                self.scrollToTop()
            }
        }
    }

    private func setupReloadReviews() {
        Task {
            let newReviews = await self.reloadReviews()
            if newReviews.isEmpty {
                isLoadingData = false
                return
            }

            reviews += newReviews
            let startIndex = reviews.count - newReviews.count
            let indexPaths = (startIndex..<reviews.count).map { IndexPath(item: $0, section: 0) }

            DispatchQueue.main.async {
                self.listCollectionView.performBatchUpdates {
                    self.listCollectionView.insertItems(at: indexPaths)
                }
            }

            isLoadingData = false
        }
    }

    private func updateCellsByBookmark(storeId: Int) {
        let indexPathsToUpdate = reviews.enumerated().compactMap { index, review in
            review.store.id == storeId ? IndexPath(item: index, section: 0) : nil
        }

        DispatchQueue.main.async {
            for indexPath in indexPathsToUpdate {
                self.reviews[indexPath.item].store.isBookmarked.toggle()

                if let cell = self.listCollectionView.cellForItem(at: indexPath) as? FeedCollectionViewCell {
                    cell.storeInfoView.bookmarkButton.isSelected.toggle()
                    cell.setNeedsLayout()
                }
            }
        }
    }
}

extension FeedListView {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard !isLoadingData else {
            return
        }

        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        let height = scrollView.frame.size.height

        if offsetY > contentHeight - height {
            isLoadingData = true
            setupReloadReviews()
        }
    }

    func scrollToTop() {
        let topOffset = CGPoint(x: 0, y: -listCollectionView.contentInset.top)
        listCollectionView.setContentOffset(topOffset, animated: true)
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

        cell.configureCell(reviews[indexPath.item])

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
                    self.parentViewController?.makeRequestAlert(
                        title: "삭제 여부",
                        message: "정말로 삭제하시겠습니까?",
                        okAction: { _ in
                            Task {
                                if await self.viewModel.removeReview(id: review.id) {
                                    self.setupLoadReviews()
                                }
                            }
                        }
                    )
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
            let storeDetailViewController = StoreDetailViewController(
                viewModel: StoreDetailViewModel(storeId: store.id, isFriend: true)
            )

            DispatchQueue.main.async { [weak self] in
                self?.parentViewController?.navigationController?.pushViewController(storeDetailViewController, animated: true)
            }
        }

        cell.bookmarkButtonTapAction = { [weak self] _ in
            guard let self = self else { return }
            Task {
                if cell.storeInfoView.bookmarkButton.isSelected {
                    if await self.viewModel.removeBookmark(storeId: store.id) {
                        self.updateCellsByBookmark(storeId: store.id)
                    }
                } else {
                    if await self.viewModel.createBookmark(storeId: store.id) {
                        self.updateCellsByBookmark(storeId: store.id)
                    }
                }
            }
        }

        return cell
    }
}
