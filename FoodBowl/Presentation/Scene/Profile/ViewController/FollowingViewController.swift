//
//  FollowingViewController.swift
//  FoodBowl
//
//  Created by COBY_PRO on 2023/01/19.
//

import Combine
import UIKit

import SnapKit
import Then

final class FollowingViewController: UIViewController, Navigationable {
    
    enum Section: CaseIterable {
        case main
    }
    
    // MARK: - ui component
    
    private let followView: FollowView = FollowView()
    
    private var dataSource: UICollectionViewDiffableDataSource<Section, MemberByFollow>!
    private var snapshot: NSDiffableDataSourceSnapshot<Section, MemberByFollow>!
    
    // MARK: - property
    
    private var cancelBag: Set<AnyCancellable> = Set()
    
    private let viewModel: FollowingViewModel
    
    // MARK: - init
    
    init(viewModel: FollowingViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - life cycle
    
    override func loadView() {
        self.view = self.followView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.bindViewModel()
        self.setupNavigation()
        self.setupNavigationBar()
    }
    
    // MARK: - func
    
    private func setupNavigationBar() {
        title = "팔로잉"
    }
    
    private func bindViewModel() {
        let output = self.transformedOutput()
        self.bindOutputToViewModel(output)
    }
    
    private func bindCell(_ cell: UserInfoCollectionViewCell, with item: MemberByFollow) {
        cell.followButtonTapAction = { [weak self] _ in
            guard let self = self else { return }
            
            Task {
                if cell.followButton.isSelected {
                    if await self.viewModel.unfollowMember(memberId: item.memberId) {
                        self.updateFollowing(memberId: item.memberId)
                    }
                } else {
                    if await self.viewModel.followMember(memberId: item.memberId) {
                        self.updateFollowing(memberId: item.memberId)
                    }
                }
            }
        }
    }
    
    private func bindOutputToViewModel(_ output: FollowingViewModel.Output) {
        output.followings
            .receive(on: DispatchQueue.main)
            .sink { _ in
            } receiveValue: { [weak self] followings in
                self?.loadFollowings(followings)
            }
            .store(in: &self.cancelBag)
        
        output.moreFollowings
            .receive(on: DispatchQueue.main)
            .sink { _ in
            } receiveValue: { [weak self] followings in
                self?.loadMoreFollowings(followings)
            }
            .store(in: &self.cancelBag)
    }
    
    private func transformedOutput() -> FollowingViewModel.Output {
        let input = FollowingViewModel.Input(
            viewDidLoad: self.viewDidLoadPublisher,
            scrolledToBottom: self.followView.collectionView().scrolledToBottomPublisher.eraseToAnyPublisher()
        )
        return viewModel.transform(from: input)
    }
}

// MARK: - DataSource
extension FollowingViewController {
    private func configureDataSource() {
        self.dataSource = self.userInfoCollectionViewDataSource()
        self.configureSnapshot()
    }

    private func userInfoCollectionViewDataSource() -> UICollectionViewDiffableDataSource<Section, MemberByFollow> {
        let reviewCellRegistration = UICollectionView.CellRegistration<UserInfoCollectionViewCell, MemberByFollow> {
            [weak self] cell, indexPath, item in
            cell.setupDataByMemberByFollow(item)
            self?.bindCell(cell, with: item)
        }

        return UICollectionViewDiffableDataSource(
            collectionView: self.followView.collectionView(),
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
extension FollowingViewController {
    private func configureSnapshot() {
        self.snapshot = NSDiffableDataSourceSnapshot<Section, MemberByFollow>()
        self.snapshot.appendSections([.main])
        self.dataSource.apply(self.snapshot, animatingDifferences: true)
    }

    private func loadFollowings(_ items: [MemberByFollow]) {
        let previousData = self.snapshot.itemIdentifiers(inSection: .main)
        self.snapshot.deleteItems(previousData)
        self.snapshot.appendItems(items, toSection: .main)
        self.dataSource.applySnapshotUsingReloadData(self.snapshot)
    }
    
    private func loadMoreFollowings(_ items: [MemberByFollow]) {
        self.snapshot.appendItems(items, toSection: .main)
        self.dataSource.applySnapshotUsingReloadData(self.snapshot)
    }
    
    private func updateFollowing(memberId: Int) {
        let previousData = self.snapshot.itemIdentifiers(inSection: .main)
        let items = previousData
            .map { customItem in
                var updatedItem = customItem
                if customItem.memberId == memberId {
                    updatedItem.isFollowing.toggle()
                }
                return updatedItem
            }
        self.snapshot.deleteItems(previousData)
        self.snapshot.appendItems(items)
        self.dataSource.applySnapshotUsingReloadData(self.snapshot)
    }
}
