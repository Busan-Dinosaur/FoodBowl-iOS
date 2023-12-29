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
    
    private lazy var storeDeatilView: StoreDetailView = StoreDetailView(storeId: self.viewModel.storeId, isFriend: self.viewModel.isFriend)
    
    private var dataSource: UICollectionViewDiffableDataSource<Section, ReviewItemByStoreDTO>!
    private var snapShot: NSDiffableDataSourceSnapshot<Section, ReviewItemByStoreDTO>!
    
    // MARK: - property
    
    private var cancelBag: Set<AnyCancellable> = Set()

    private let viewModel: StoreDetailViewModel

    // MARK: - init
    
    init(viewModel: StoreDetailViewModel) {
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
        self.view = self.storeDeatilView
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
    
    private func bindOutputToViewModel(_ output: StoreDetailViewModel.Output) {
        output.reviews
            .receive(on: DispatchQueue.main)
            .sink { [weak self] result in
                switch result {
                case .failure:
                    self?.handleReviews([])
                case .finished:
                    return
                }
            } receiveValue: { [weak self] reviews in
                self?.handleReviews(reviews)
            }
            .store(in: &self.cancelBag)
        
        output.refreshControl
            .receive(on: DispatchQueue.main)
            .sink { _ in
            } receiveValue: { [weak self] _ in
                self?.storeDeatilView.refreshControl.endRefreshing()
            }
            .store(in: &self.cancelBag)
    }
    
    private func bindUI() {
        self.storeDeatilView.reviewToggleButtonDidTapPublisher
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { [weak self] isFriend in
                self?.title = isFriend ? "친구들의 후기" : "모두의 후기"
            })
            .store(in: &self.cancelBag)
    }
    
    private func bindCell(_ cell: FeedNSCollectionViewCell, with item: ReviewItemByStoreDTO) {
        cell.userButtonTapAction = { [weak self] _ in
            let profileViewController = ProfileViewController(memberId: item.writer.id)
            
            DispatchQueue.main.async { [weak self] in
                self?.navigationController?.pushViewController(profileViewController, animated: true)
            }
        }
        
        cell.optionButtonTapAction = { [weak self] _ in
            let isOwn = UserDefaultsManager.currentUser?.id ?? 0 == item.writer.id
            
            DispatchQueue.main.async { [weak self] in
                self?.presentReviewOptionAlert(isOwn: isOwn, reviewId: item.review.id)
            }
        }
    }
    
    // MARK: - func
    
    private func configureNavigation() {
        guard let navigationController = self.navigationController else { return }
        self.storeDeatilView.configureNavigationBarItem(navigationController)
        self.storeDeatilView.configureNavigationBarTitle(navigationController)
    }
    
    private func transformedOutput() -> StoreDetailViewModel.Output {
        let input = StoreDetailViewModel.Input(
            reviewToggleButtonDidTap: self.storeDeatilView.reviewToggleButtonDidTapPublisher.eraseToAnyPublisher(),
            scrolledToBottom: self.storeDeatilView.listCollectionView.scrolledToBottomPublisher.eraseToAnyPublisher(),
            refreshControl: self.storeDeatilView.refreshPublisher.eraseToAnyPublisher()
        )

        return self.viewModel.transform(from: input)
    }
    
    func removeReview(reviewId: Int) {
        Task {
            if await self.viewModel.removeReview(id: reviewId) {
                
            }
        }
    }
}

// MARK: - Helper
extension StoreDetailViewController {
    private func handleReviews(_ reviews: [ReviewItemByStoreDTO]) {
        self.reloadReviews(reviews)
    }
}

// MARK: - DataSource
extension StoreDetailViewController {
    private func configureDataSource() {
        self.dataSource = self.feedNSCollectionViewDataSource()
        self.configureSnapshot()
    }

    private func feedNSCollectionViewDataSource() -> UICollectionViewDiffableDataSource<Section, ReviewItemByStoreDTO> {
        let reviewCellRegistration = UICollectionView.CellRegistration<FeedNSCollectionViewCell, ReviewItemByStoreDTO> {
            [weak self] cell, indexPath, item in
            
            cell.configureCell(item)
            self?.bindCell(cell, with: item)
        }

        return UICollectionViewDiffableDataSource(
            collectionView: self.storeDeatilView.collectionView(),
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
        self.snapShot = NSDiffableDataSourceSnapshot<Section, ReviewItemByStoreDTO>()
        self.snapShot.appendSections([.main])
        self.dataSource.apply(self.snapShot, animatingDifferences: true)
    }

    private func reloadReviews(_ items: [ReviewItemByStoreDTO]) {
        let previousReviewsData = self.snapShot.itemIdentifiers(inSection: .main)
        self.snapShot.deleteItems(previousReviewsData)
        self.snapShot.appendItems(items, toSection: .main)
        self.dataSource.apply(self.snapShot, animatingDifferences: true)
    }
}
