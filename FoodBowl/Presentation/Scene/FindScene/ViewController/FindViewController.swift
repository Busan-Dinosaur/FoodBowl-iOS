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
    
    private var scope: Int = 0
    private var stores: [Store] = []
    private var members: [Member] = []
    
    private let selectStorePublisher = PassthroughSubject<Place, Never>()
    private let searchStoresAndMembersPublisher = PassthroughSubject<String, Never>()
    private let followButtonDidTapPublisher = PassthroughSubject<(Int, Bool), Never>()
    
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
            refreshControl: self.findView.refreshPublisher.eraseToAnyPublisher(),
            searchStoresAndMembers: self.searchStoresAndMembersPublisher.eraseToAnyPublisher(),
            followMember: self.followButtonDidTapPublisher.eraseToAnyPublisher()
        )
        return viewModel.transform(from: input)
    }
    
    private func bindOutputToViewModel(_ output: FindViewModel.Output?) {
        guard let output else { return }
        
        output.reviews
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { [weak self] result in
                switch result {
                case .success(let reviews):
                    self?.reloadReviews(reviews)
                    self?.findView.refreshControl().endRefreshing()
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
        
        output.storesAndMembers
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { [weak self] result in
                switch result {
                case .success((let stores, let members)):
                    self?.stores = stores
                    self?.members = members
                    self?.findView.findResultViewController.findResultView.listTableView.reloadData()
                case .failure(let error):
                    self?.makeAlert(
                        title: "에러",
                        message: error.localizedDescription
                    )
                }
            })
            .store(in: &self.cancellable)
        
        output.followMember
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { [weak self] result in
                switch result {
                case .success(let memberId):
                    self?.followMember(memberId: memberId)
                case .failure(let error):
                    self?.makeAlert(
                        title: "에러",
                        message: error.localizedDescription
                    )
                }
            })
            .store(in: &self.cancellable)
    }
    
    private func bindUI() {
        self.findView.plusButtonDidTapPublisher
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { [weak self] _ in
                self?.presentCreateReviewController()
            })
            .store(in: &self.cancellable)
    }
    
    // MARK: - func
    
    private func configureDelegation() {
        self.findView.findResultViewController.findResultView.listTableView.delegate = self
        self.findView.findResultViewController.findResultView.listTableView.dataSource = self
        self.findView.searchController.searchResultsUpdater = self
        self.findView.searchController.searchBar.delegate = self
    }
    
    private func configureNavigation() {
        guard let navigationController = self.navigationController else { return }
        self.findView.configureNavigationBarItem(navigationController)
    }
    
    private func followMember(memberId: Int) {
        if let index = self.members.firstIndex(where: { $0.id == memberId }) {
            self.members[index].isFollowing.toggle()
            let indexPath = IndexPath(row: index, section: 0)
            self.findView.findResultViewController.findResultView.listTableView.reloadRows(at: [indexPath], with: .fade)
        }
    }
}

// MARK: - Helper
extension FindViewController {
    private func presentCreateReviewController() {
        let repository = CreateReviewRepositoryImpl()
        let usecase = CreateReviewUsecaseImpl(repository: repository)
        let viewModel = CreateReviewViewModel(usecase: usecase)
        let viewController = CreateReviewViewController(viewModel: viewModel)
        let navigationController = UINavigationController(rootViewController: viewController)
        navigationController.modalPresentationStyle = .fullScreen
        self.present(navigationController, animated: true)
    }
}

// MARK: - DataSource
extension FindViewController {
    private func configureDataSource() {
        self.dataSource = self.feedCollectionViewDataSource()
        self.configureSnapshot()
    }

    private func feedCollectionViewDataSource() -> UICollectionViewDiffableDataSource<Section, ReviewItem> {
        let reviewCellRegistration = UICollectionView.CellRegistration<PhotoCollectionViewCell, ReviewItem> { cell, indexPath, item in
            cell.configureCell(item.thumbnail)
            cell.cellAction = { [weak self] _ in
                print(item.comment.id)
            }
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

extension FindViewController: UISearchResultsUpdating, UISearchBarDelegate {
    func updateSearchResults(for searchController: UISearchController) {
        guard let text = searchController.searchBar.text?.lowercased(), text != "" else {
            self.stores = []
            self.members = []
            self.findView.findResultViewController.findResultView.listTableView.reloadData()
            return
        }
        self.searchStoresAndMembersPublisher.send(text)
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        self.stores = []
        self.members = []
        self.findView.findResultViewController.findResultView.listTableView.reloadData()
        self.findView.searchController.searchBar.showsScopeBar = false
    }

    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        self.findView.searchController.searchBar.showsScopeBar = true
    }

    func searchBar(_ searchBar: UISearchBar, selectedScopeButtonIndexDidChange selectedScope: Int) {
        self.scope = selectedScope
        self.findView.findResultViewController.findResultView.listTableView.reloadData()
    }
}

extension FindViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_: UITableView, numberOfRowsInSection _: Int) -> Int {
        if self.scope == 0 {
            return self.stores.count
        } else {
            return self.members.count
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if self.scope == 0 {
            guard let cell = tableView.dequeueReusableCell(
                withIdentifier: StoreInfoTableViewCell.className,
                for: indexPath
            ) as? StoreInfoTableViewCell else {
                return UITableViewCell()
            }

            cell.selectionStyle = .none
            cell.configureCell(self.stores[indexPath.item])

            return cell
        } else {
            guard let cell = tableView.dequeueReusableCell(
                withIdentifier: UserInfoTableViewCell.className,
                for: indexPath
            ) as? UserInfoTableViewCell else {
                return UITableViewCell()
            }
            
            cell.selectionStyle = .none
            cell.configureCell(self.members[indexPath.item])
            cell.followButtonTapAction = { [weak self] _ in
                guard let self = self else { return }
                self.followButtonDidTapPublisher.send((self.members[indexPath.item].id, self.members[indexPath.item].isFollowing))
            }

            return cell
        }
    }

    func tableView(_: UITableView, heightForRowAt _: IndexPath) -> CGFloat {
        return 64
    }

    func tableView(_: UITableView, didSelectRowAt indexPath: IndexPath) {
        if self.scope == 0 {
            let repository = StoreDetailRepositoryImpl()
            let usecase = StoreDetailUsecaseImpl(repository: repository)
            let viewModel = StoreDetailViewModel(usecase: usecase, storeId: self.stores[indexPath.item].id, isFriend: false)
            let viewController = StoreDetailViewController(viewModel: viewModel)

            DispatchQueue.main.async { [weak self] in
                self?.navigationController?.pushViewController(viewController, animated: true)
            }
        } else {
            let profileViewController = ProfileViewController(memberId: self.members[indexPath.item].id)
            DispatchQueue.main.async { [weak self] in
                self?.navigationController?.pushViewController(profileViewController, animated: true)
            }
        }
    }
}
