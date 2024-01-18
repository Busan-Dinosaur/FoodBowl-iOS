//
//  FindViewController.swift
//  FoodBowl
//
//  Created by COBY_PRO on 2023/07/24.
//

import Combine
import UIKit

import SnapKit
import Then

final class FindViewController: UIViewController, Keyboardable {
    
    enum Section: CaseIterable {
        case main
    }
    
    // MARK: - ui component
    
    private let findView: FindView = FindView()
    
    // MARK: - property
    
    private let viewModel: any BaseViewModelType
    private var cancellable: Set<AnyCancellable> = Set()
    
    private var dataSource: UICollectionViewDiffableDataSource<Section, ReviewItem>!
    private var snapshot: NSDiffableDataSourceSnapshot<Section, ReviewItem>!
    private var reviewId: Int = 0
    
    let selectStorePublisher = PassthroughSubject<Place, Never>()
    
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
        self.view = self.findView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureDataSource()
        self.configureDelegation()
        self.bindViewModel()
        self.bindUI()
        self.setupKeyboardGesture()
    }
    
    // MARK: - func - bind
    
    private func bindViewModel() {
        let output = self.transformedOutput()
        self.configureNavigation()
        self.bindOutputToViewModel(output)
    }

    private func transformedOutput() -> FindViewModel.Output? {
        guard let viewModel = self.viewModel as? FindViewModel else { return nil }
        let input = FindViewModel.Input(
            scrolledToBottom: self.findView.collectionView().scrolledToBottomPublisher.eraseToAnyPublisher(),
            refreshControl: self.findView.refreshPublisher.eraseToAnyPublisher()
        )
        return viewModel.transform(from: input)
    }
    
    private func bindOutputToViewModel(_ output: FindViewModel.Output?) {
        guard let output else { return }
        
        output.reviews
            .receive(on: DispatchQueue.main)
            .sink { _ in
            } receiveValue: { [weak self] reviews in
                self?.reloadReviews(reviews)
                self?.findView.refreshControl().endRefreshing()
            }
            .store(in: &self.cancellable)
        
        output.moreReviews
            .receive(on: DispatchQueue.main)
            .sink { _ in
            } receiveValue: { [weak self] reviews in
                self?.loadMoreReviews(reviews)
            }
            .store(in: &self.cancellable)
        
        output.stores
            .receive(on: DispatchQueue.main)
            .sink { _ in
            } receiveValue: { [weak self] stores in
                print("success")
            }
            .store(in: &self.cancellable)
        
        output.members
            .receive(on: DispatchQueue.main)
            .sink { _ in
            } receiveValue: { [weak self] members in
                print("success")
            }
            .store(in: &self.cancellable)
    }
    
    private func bindUI() {
        self.findView.plusButtonDidTapPublisher
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { [weak self] _ in
                self?.navigationController?.popViewController(animated: true)
            })
            .store(in: &self.cancellable)
    }
    
    // MARK: - func
    
    private func configureDelegation() {
        self.findView.findResultViewController.searchResultTableView.delegate = self
        self.findView.findResultViewController.searchResultTableView.dataSource = self
        self.findView.searchController.searchResultsUpdater = self
        self.findView.searchController.searchBar.delegate = self
    }
    
    private func configureNavigation() {
        guard let navigationController = self.navigationController else { return }
        self.findView.configureNavigationBarItem(navigationController)
    }
}

extension FindViewController: UISearchResultsUpdating, UISearchBarDelegate {
    func updateSearchResults(for searchController: UISearchController) {
        guard let text = searchController.searchBar.text?.lowercased() else { return }
        self.findView.searchText = text
    }

    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        self.findView.searchController.searchBar.showsScopeBar = true
    }

    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        self.findView.searchController.searchBar.showsScopeBar = false
    }

    func searchBar(_ searchBar: UISearchBar, selectedScopeButtonIndexDidChange selectedScope: Int) {
        self.findView.scope = selectedScope
        self.findView.findResultViewController.searchResultTableView.reloadData()
    }
}

// MARK: - DataSource
extension FindViewController {
    private func configureDataSource() {
        self.dataSource = self.feedCollectionViewDataSource()
        self.configureSnapshot()
    }

    private func feedCollectionViewDataSource() -> UICollectionViewDiffableDataSource<Section, ReviewItem> {
        let reviewCellRegistration = UICollectionView.CellRegistration<PhotoCollectionViewCell, ReviewItem> {
            [weak self] cell, indexPath, item in
            self?.reviewId = item.comment.id
            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self?.feedDidTap))
            cell.addGestureRecognizer(tapGesture)
            cell.configureCell(item.thumbnail)
        }

        return UICollectionViewDiffableDataSource(
            collectionView: self.findView.collectionView(),
            cellProvider: { collectionView, indexPath, item in
                return collectionView.dequeueConfiguredReusableCell(
                    using: reviewCellRegistration,
                    for: indexPath,
                    item: item
                )
            }
        )
    }
    
    @objc
    private func feedDidTap() {
        print(self.reviewId)
    }
}

// MARK: - Snapshot
extension FindViewController {
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
}

extension FindViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_: UITableView, numberOfRowsInSection _: Int) -> Int {
        if self.findView.scope == 0 {
            return self.findView.stores.count
        } else {
            return self.findView.members.count
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if self.findView.scope == 0 {
            guard let cell = tableView.dequeueReusableCell(
                withIdentifier: StoreInfoTableViewCell.className,
                for: indexPath
            ) as? StoreInfoTableViewCell else {
                return UITableViewCell()
            }

            cell.selectionStyle = .none
            cell.setupData(self.findView.stores[indexPath.item])

            return cell
        } else {
            guard let cell = tableView.dequeueReusableCell(
                withIdentifier: UserInfoTableViewCell.className,
                for: indexPath
            ) as? UserInfoTableViewCell else {
                return UITableViewCell()
            }
            
            cell.selectionStyle = .none
            cell.setupData(self.findView.members[indexPath.item])

            return cell
        }
    }

    func tableView(_: UITableView, heightForRowAt _: IndexPath) -> CGFloat {
        return 64
    }

    func tableView(_: UITableView, didSelectRowAt indexPath: IndexPath) {
        if self.findView.scope == 0 {
            let repository = StoreDetailRepositoryImpl()
            let usecase = StoreDetailUsecaseImpl(repository: repository)
            let viewModel = StoreDetailViewModel(storeId: self.findView.stores[indexPath.item].id, isFriend: false, usecase: usecase)
            let viewController = StoreDetailViewController(viewModel: viewModel)

            DispatchQueue.main.async { [weak self] in
                self?.navigationController?.pushViewController(viewController, animated: true)
            }
        } else {
            let profileViewController = ProfileViewController(memberId: self.findView.members[indexPath.item].id)
            DispatchQueue.main.async { [weak self] in
                self?.navigationController?.pushViewController(profileViewController, animated: true)
            }
        }
    }
}

extension FindViewController: CreateReviewViewControllerDelegate {
    func updateData() {
//        loadData()
    }
}
