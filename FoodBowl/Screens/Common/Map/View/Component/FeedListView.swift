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
            setupListCollectionView()
        }
    }

    private let viewModel = BaseViewModel()

    var loadReviews: () async -> [Review]
    var loadStores: () async -> [Store]
    var reloadReviews: () async -> [Review]
    var presentBlameVC: (Int, String) -> Void

    private let refreshControl = UIRefreshControl()

    // MARK: - init
    init(
        loadReviews: @escaping (() async -> [Review]),
        loadStores: @escaping (() async -> [Store]),
        reloadReviews: @escaping (() async -> [Review]),
        presentBlameVC: @escaping (Int, String) -> Void
    ) {
        self.loadReviews = loadReviews
        self.loadStores = loadStores
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
//            self?.loadReviews()
        }
        refreshControl.addAction(action, for: .valueChanged)
        refreshControl.tintColor = .grey002
        listCollectionView.refreshControl = refreshControl
    }

    private func setupListCollectionView() {}
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
//        reloadReviews()
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
                    self.parentViewController?.makeRequestAlert(
                        title: "삭제 여부",
                        message: "정말로 삭제하시겠습니까?",
                        okAction: { _ in
                            Task {
                                if await self.viewModel.removeReview(id: review.id) {
                                    //                                self.loadReviews()
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
                        self.reviews = self.reviews.map {
                            var review = $0
                            if $0.store.id == store.id {
                                review.store.isBookmarked = false
                                return review
                            }
                            return review
                        }
                    }
                } else {
                    if await self.viewModel.createBookmark(storeId: store.id) {
                        self.reviews = self.reviews.map {
                            var review = $0
                            if $0.store.id == store.id {
                                review.store.isBookmarked = true
                                return review
                            }
                            return review
                        }
                    }
                }
            }
        }

        return cell
    }
}
