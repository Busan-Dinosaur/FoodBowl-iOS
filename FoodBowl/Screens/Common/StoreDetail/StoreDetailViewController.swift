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

final class StoreDetailViewController: UIViewController, Navigationable, Keyboardable {
    
    enum Section: CaseIterable {
        case main
    }
    
    // MARK: - ui component
    
    private lazy var storeDeatilView: StoreDeatilView = StoreDeatilView(storeId: self.viewModel.storeId, isFriend: self.viewModel.isFriend)
    
    private var dataSource: UICollectionViewDiffableDataSource<Section, ReviewByStore>!
    private var snapShot: NSDiffableDataSourceSnapshot<Section, ReviewByStore>!
    
    // MARK: - property
    
    private var cancelBag: Set<AnyCancellable> = Set()

    private let viewModel: StoreDetailViewModel

    private weak var delegate: StoreDetailViewDelegate?

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
        self.configureDelegation()
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
    }
    
    private func bindUI() {
        self.storeDeatilView.reviewToggleButtonDidTapPublisher
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { [weak self] isFriend in
                self?.title = isFriend ? "친구들의 후기" : "모두의 후기"
            })
            .store(in: &self.cancelBag)
    }
    
    private func bindCell(_ cell: FeedNSCollectionViewCell, with item: ReviewByStore) {
    }
    
    // MARK: - func
    
    private func configureDelegation() {
        self.storeDeatilView.configureDelegate(self)
    }
    
    private func configureNavigation() {
        guard let navigationController = self.navigationController else { return }
        self.storeDeatilView.configureNavigationBarItem(navigationController)
        self.storeDeatilView.configureNavigationBarTitle(navigationController)
    }
    
    private func transformedOutput() -> StoreDetailViewModel.Output {
        let input = StoreDetailViewModel.Input(
            viewDidLoad: self.viewDidLoadPublisher,
            reviewToggleButtonDidTap: self.storeDeatilView.reviewToggleButtonDidTapPublisher.eraseToAnyPublisher()
        )

        return self.viewModel.transform(from: input)
    }
}

// MARK: - Helper
extension StoreDetailViewController {
    private func handleReviews(_ reviews: [ReviewByStore]) {
        self.reloadReviews(reviews)
    }
}

// MARK: - DataSource
extension StoreDetailViewController {
    private func configureDataSource() {
        self.dataSource = self.feedNSCollectionViewDataSource()
        self.configureSnapshot()
    }

    private func feedNSCollectionViewDataSource() -> UICollectionViewDiffableDataSource<Section, ReviewByStore> {
        let reviewCellRegistration = UICollectionView.CellRegistration<FeedNSCollectionViewCell, ReviewByStore> {
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
        self.snapShot = NSDiffableDataSourceSnapshot<Section, ReviewByStore>()
        self.snapShot.appendSections([.main])
        self.dataSource.apply(self.snapShot, animatingDifferences: true)
    }

    private func reloadReviews(_ items: [ReviewByStore]) {
        let previousReviewsData = self.snapShot.itemIdentifiers(inSection: .main)
        self.snapShot.deleteItems(previousReviewsData)
        self.snapShot.appendItems(items, toSection: .main)
        self.dataSource.apply(self.snapShot, animatingDifferences: true)
    }
}

extension StoreDetailViewController: StoreDetailViewDelegate {
}
