//
//  StoreDetailViewController.swift
//  FoodBowl
//
//  Created by COBY_PRO on 2023/01/18.
//

import Combine
import UIKit

import SnapKit
import Then

final class StoreDetailViewController: UIViewController, Navigationable, Optionable {
    
    enum Section: CaseIterable {
        case main
    }
    
    // MARK: - ui component
    
    private let storeDetailView: StoreDetailView = StoreDetailView()
    
    // MARK: - property
    
    private let viewModel: any BaseViewModelType
    private var cancellable: Set<AnyCancellable> = Set()
    
    private var dataSource: UICollectionViewDiffableDataSource<Section, ReviewItem>!
    private var snapshot: NSDiffableDataSourceSnapshot<Section, ReviewItem>!
    
    let removeReviewPublisher = PassthroughSubject<Int, Never>()

    // MARK: - init
    
    init(viewModel: any BaseViewModelType) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        print("\(#file) is dead")
    }
    
    // MARK: - life cycle

    override func loadView() {
        self.view = self.storeDetailView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureDataSource()
        self.bindViewModel()
        self.bindUI()
        self.setupNavigation()
    }
    
    // MARK: - func - bind

    private func bindViewModel() {
        let output = self.transformedOutput()
        self.configureNavigation()
        self.bindOutputToViewModel(output)
    }
    
    private func transformedOutput() -> StoreDetailViewModel.Output? {
        guard let viewModel = self.viewModel as? StoreDetailViewModel else { return nil }
        let input = StoreDetailViewModel.Input(
            reviewToggleButtonDidTap: self.storeDetailView.reviewToggleButtonDidTapPublisher.eraseToAnyPublisher(),
            bookmarkButtonDidTap: self.storeDetailView.bookmarkButtonDidTapPublisher.eraseToAnyPublisher(),
            removeReview: self.removeReviewPublisher.eraseToAnyPublisher(),
            scrolledToBottom: self.storeDetailView.collectionView().scrolledToBottomPublisher.eraseToAnyPublisher(),
            refreshControl: self.storeDetailView.refreshPublisher.eraseToAnyPublisher()
        )
        return viewModel.transform(from: input)
    }
    
    private func bindOutputToViewModel(_ output: StoreDetailViewModel.Output?) {
        guard let output else { return }
        
        output.store
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { [weak self] result in
                switch result {
                case .success(let store):
                    self?.storeDetailView.storeHeaderView.configureHeader(store)
                case .failure(let error):
                    self?.makeAlert(
                        title: "에러",
                        message: error.localizedDescription
                    )
                }
            })
            .store(in: &self.cancellable)
        
        output.reviews
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { [weak self] result in
                switch result {
                case .success(let reviews):
                    self?.reloadReviews(reviews)
                    self?.storeDetailView.refreshControl().endRefreshing()
                case .failure(let error):
                    self?.makeAlert(
                        title: "에러",
                        message: error.localizedDescription
                    )
                }
            })
            .store(in: &self.cancellable)
        
        output.moreReviews
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { [weak self] result in
                switch result {
                case .success(let reviews):
                    self?.loadMoreReviews(reviews)
                case .failure(let error):
                    self?.makeAlert(
                        title: "에러",
                        message: error.localizedDescription
                    )
                }
            })
            .store(in: &self.cancellable)
        
        output.isRemoved
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { [weak self] result in
                switch result {
                case .success(let id):
                    self?.deleteReview(id)
                case .failure(let error):
                    self?.makeAlert(
                        title: "에러",
                        message: error.localizedDescription
                    )
                }
            })
            .store(in: &self.cancellable)
        
        output.errorAlert
            .sink(receiveValue: { [weak self] message in
                self?.makeAlert(
                    title: "에러",
                    message: message
                )
            })
            .store(in: &self.cancellable)
        
    }
    
    private func bindUI() {
        self.storeDetailView.reviewToggleButtonDidTapPublisher
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { [weak self] isFriend in
                self?.title = isFriend ? "친구들의 후기" : "모두의 후기"
            })
            .store(in: &self.cancellable)
    }
    
    private func bindCell(_ cell: FeedNSCollectionViewCell, with item: ReviewItem) {
        cell.userButtonTapAction = { [weak self] _ in
            let profileViewController = ProfileViewController(memberId: item.member.id)
            
            DispatchQueue.main.async { [weak self] in
                self?.navigationController?.pushViewController(profileViewController, animated: true)
            }
        }
        
        cell.optionButtonTapAction = { [weak self] _ in
            let isOwn = UserDefaultStorage.id == item.member.id
            
            DispatchQueue.main.async { [weak self] in
                self?.presentReviewOptionAlert(isOwn: isOwn, reviewId: item.comment.id)
            }
        }
    }
    
    // MARK: - func
    
    private func configureNavigation() {
        guard let viewModel = self.viewModel as? StoreDetailViewModel else { return }
        guard let navigationController = self.navigationController else { return }
        self.storeDetailView.reviewToggleButton.isSelected = viewModel.isFriend
        self.storeDetailView.configureNavigationBarItem(navigationController)
        self.storeDetailView.configureNavigationBarTitle(navigationController)
    }
    
    func removeReview(reviewId: Int) {
        removeReviewPublisher.send(reviewId)
    }
}

// MARK: - DataSource
extension StoreDetailViewController {
    private func configureDataSource() {
        self.dataSource = self.feedNSCollectionViewDataSource()
        self.configureSnapshot()
    }

    private func feedNSCollectionViewDataSource() -> UICollectionViewDiffableDataSource<Section, ReviewItem> {
        let reviewCellRegistration = UICollectionView.CellRegistration<FeedNSCollectionViewCell, ReviewItem> {
            [weak self] cell, indexPath, item in
            
            cell.configureCell(item)
            self?.bindCell(cell, with: item)
        }

        return UICollectionViewDiffableDataSource(
            collectionView: self.storeDetailView.collectionView(),
            cellProvider: { collectionView, indexPath, item in
                return collectionView.dequeueConfiguredReusableCell(
                    using: reviewCellRegistration,
                    for: indexPath,
                    item: item
                )
            }
        )
    }
}

// MARK: - Snapshot
extension StoreDetailViewController {
    private func configureSnapshot() {
        self.snapshot = NSDiffableDataSourceSnapshot<Section, ReviewItem>()
        self.snapshot.appendSections([.main])
        self.dataSource.apply(self.snapshot, animatingDifferences: true)
    }

    private func reloadReviews(_ items: [ReviewItem]) {
        let previousReviewsData = self.snapshot.itemIdentifiers(inSection: .main)
        self.snapshot.deleteItems(previousReviewsData)
        self.snapshot.appendItems(items, toSection: .main)
        self.dataSource.applySnapshotUsingReloadData(self.snapshot)
    }
    
    private func loadMoreReviews(_ items: [ReviewItem]) {
        self.snapshot.appendItems(items, toSection: .main)
        self.dataSource.applySnapshotUsingReloadData(self.snapshot)
    }
    
    private func deleteReview(_ reviewId: Int) {
        for item in snapshot.itemIdentifiers {
            if item.comment.id == reviewId {
                self.snapshot.deleteItems([item])
                self.dataSource.apply(self.snapshot)
                return
            }
        }
    }
}
