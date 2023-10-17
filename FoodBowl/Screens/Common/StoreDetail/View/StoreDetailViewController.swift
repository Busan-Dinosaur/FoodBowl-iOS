//
//  StoreDetailViewController.swift
//  FoodBowl
//
//  Created by COBY_PRO on 2023/01/18.
//

import MessageUI
import UIKit

import SnapKit
import Then

final class StoreDetailViewController: BaseViewController {
    private enum Size {
        static let collectionInset = UIEdgeInsets(
            top: 0,
            left: 0,
            bottom: 20,
            right: 0
        )
    }

    private var storeId: Int
    private var isFriend: Bool = true
    private var reviews = [ReviewByStore]() {
        didSet {
            DispatchQueue.main.async {
                self.listCollectionView.reloadData()
                self.refreshControl.endRefreshing()
            }
        }
    }

    private var viewModel = StoreDetailViewModel()

    init(storeId: Int) {
        self.storeId = storeId
        super.init()
    }

    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - property
    private var refreshControl = UIRefreshControl()

    private lazy var reviewToggleButton = ReviewToggleButton().then {
        let action = UIAction { [weak self] _ in
            self?.reviewToggleButtonTapped()
        }
        $0.addAction(action, for: .touchUpInside)
    }

    private var storeHeaderView = StoreHeaderView()

    private let collectionViewFlowLayout = DynamicHeightCollectionViewFlowLayout().then {
        $0.sectionInset = Size.collectionInset
        $0.minimumLineSpacing = 20
        $0.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
    }

    private lazy var listCollectionView = UICollectionView(frame: .zero, collectionViewLayout: collectionViewFlowLayout).then {
        $0.dataSource = self
        $0.delegate = self
        $0.showsVerticalScrollIndicator = false
        $0.register(FeedNSCollectionViewCell.self, forCellWithReuseIdentifier: FeedNSCollectionViewCell.className)
        $0.backgroundColor = .mainBackgroundColor
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupRefreshControl()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadData()
    }

    override func setupLayout() {
        view.addSubviews(storeHeaderView, listCollectionView)

        storeHeaderView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(50)
        }

        listCollectionView.snp.makeConstraints {
            $0.top.equalTo(storeHeaderView.snp.bottom)
            $0.leading.trailing.bottom.equalToSuperview()
        }
    }

    override func setupNavigationBar() {
        super.setupNavigationBar()
        let reviewToggleButton = makeBarButtonItem(with: reviewToggleButton)
        navigationItem.rightBarButtonItem = reviewToggleButton
        title = "친구들의 리뷰"
    }

    private func reviewToggleButtonTapped() {
        reviewToggleButton.isSelected.toggle()
        isFriend.toggle()

        title = isFriend ? "친구들의 후기" : "모두의 후기"

        loadData()
    }

    private func setupRefreshControl() {
        let action = UIAction { [weak self] _ in
            self?.loadData()
        }
        refreshControl.addAction(action, for: .valueChanged)
        refreshControl.tintColor = .grey002
        listCollectionView.refreshControl = refreshControl
    }

    override func loadData() {
        Task {
            await loadReviews()
        }
    }

    override func reloadData() {
        Task {
            await reloadReviews()
        }
    }

    private func loadReviews() async {
        let filter = isFriend ? "FRIEND" : "ALL"
        reviews = await viewModel.getReviews(storeId: storeId, filter: filter)
    }

    private func reloadReviews() async {
        let filter = isFriend ? "FRIEND" : "ALL"
        reviews = await viewModel.getReviews(storeId: storeId, filter: filter, lastReviewId: viewModel.lastReviewId)
    }
}

extension StoreDetailViewController {
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
extension StoreDetailViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_: UICollectionView, numberOfItemsInSection _: Int) -> Int {
        return reviews.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: FeedNSCollectionViewCell.className,
            for: indexPath
        ) as? FeedNSCollectionViewCell else {
            return UICollectionViewCell()
        }

        let member = reviews[indexPath.item].writer
        let review = reviews[indexPath.item].review
        let isOwn = UserDefaultsManager.currentUser?.id ?? 0 == member.id

        cell.userInfoView.setupData(member)
        cell.setupData(review)

        cell.userButtonTapAction = { [weak self] _ in
            let profileViewController = ProfileViewController(memberId: member.id)

            DispatchQueue.main.async { [weak self] in
                self?.navigationController?.pushViewController(profileViewController, animated: true)
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
                        self?.present(navigationController, animated: true)
                    }
                })
                alert.addAction(edit)

                let del = UIAlertAction(title: "삭제", style: .destructive, handler: { _ in
                    guard let self = self else { return }
                    self.showDeleteAlert {
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
                    self?.presentBlameViewController()
                })
                alert.addAction(report)
            }

            let cancel = UIAlertAction(title: "취소", style: .cancel, handler: nil)
            alert.addAction(cancel)

            DispatchQueue.main.async { [weak self] in
                self?.present(alert, animated: true, completion: nil)
            }
        }

        return cell
    }
}
