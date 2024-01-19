//
//  FollowerViewController.swift
//  FoodBowl
//
//  Created by COBY_PRO on 2023/01/19.
//

import Combine
import UIKit

import SnapKit
import Then

final class FollowerViewController: UIViewController, Navigationable {
    
    enum Section: CaseIterable {
        case main
    }
    
    // MARK: - ui component
    
    private let followView: FollowView = FollowView()
    
    private var dataSource: UICollectionViewDiffableDataSource<Section, MemberByFollowItemDTO>!
    private var snapshot: NSDiffableDataSourceSnapshot<Section, MemberByFollowItemDTO>!
    
    // MARK: - property
    
    private var cancellable: Set<AnyCancellable> = Set()
    
    private let viewModel: FollowerViewModel
    
    // MARK: - init
    
    init(viewModel: FollowerViewModel) {
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
        self.configureDataSource()
        self.bindViewModel()
        self.setupNavigation()
        self.setupNavigationBar()
    }
    
    // MARK: - func
    
    private func setupNavigationBar() {
        title = "팔로워"
    }
    
    private func bindViewModel() {
        let output = self.transformedOutput()
        self.bindOutputToViewModel(output)
    }
    
    private func bindCell(_ cell: UserInfoCollectionViewCell, with item: MemberByFollowItemDTO) {
        cell.userButtonTapAction = { [weak self] _ in
            let profileViewController = ProfileViewController(memberId: item.memberId)
            
            DispatchQueue.main.async { [weak self] in
                self?.navigationController?.pushViewController(profileViewController, animated: true)
            }
        }
        
        if UserDefaultStorage.id == item.memberId {
            cell.followButton.isHidden = true
        } else {
            cell.followButton.isHidden = false
        }
        
        if self.viewModel.isOwn {
            cell.followButton.isSelected = true
        } else {
            cell.followButton.isSelected = item.isFollowing
        }
        
        cell.followButtonTapAction = { [weak self] _ in
            guard let self = self else { return }
            
            Task {
                if self.viewModel.isOwn {
                    if await self.viewModel.removeFollowingMember(memberId: item.memberId) {
                        DispatchQueue.main.async {
                            self.deleteFollower(memberId: item.memberId)
                        }
                    }
                } else {
                    if cell.followButton.isSelected {
                        if await self.viewModel.unfollowMember(memberId: item.memberId) {
                            DispatchQueue.main.async {
                                self.updateFollower(memberId: item.memberId)
                            }
                        }
                    } else {
                        if await self.viewModel.followMember(memberId: item.memberId) {
                            DispatchQueue.main.async {
                                self.updateFollower(memberId: item.memberId)
                            }
                        }
                    }
                }
            }
        }
    }
    
    private func bindOutputToViewModel(_ output: FollowerViewModel.Output) {
        output.followers
            .receive(on: DispatchQueue.main)
            .sink { _ in
            } receiveValue: { [weak self] followers in
                self?.loadFollowers(followers)
            }
            .store(in: &self.cancellable)
        
        output.moreFollowers
            .receive(on: DispatchQueue.main)
            .sink { _ in
            } receiveValue: { [weak self] followers in
                self?.loadMoreFollowers(followers)
            }
            .store(in: &self.cancellable)
    }
    
    private func transformedOutput() -> FollowerViewModel.Output {
        let input = FollowerViewModel.Input(
            viewDidLoad: self.viewDidLoadPublisher,
            scrolledToBottom: self.followView.collectionView().scrolledToBottomPublisher.eraseToAnyPublisher()
        )
        return viewModel.transform(from: input)
    }
}

// MARK: - DataSource
extension FollowerViewController {
    private func configureDataSource() {
        self.dataSource = self.userInfoCollectionViewDataSource()
        self.configureSnapshot()
    }

    private func userInfoCollectionViewDataSource() -> UICollectionViewDiffableDataSource<Section, MemberByFollowItemDTO> {
        let reviewCellRegistration = UICollectionView.CellRegistration<UserInfoCollectionViewCell, MemberByFollowItemDTO> {
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
extension FollowerViewController {
    private func configureSnapshot() {
        self.snapshot = NSDiffableDataSourceSnapshot<Section, MemberByFollowItemDTO>()
        self.snapshot.appendSections([.main])
        self.dataSource.apply(self.snapshot, animatingDifferences: true)
    }

    private func loadFollowers(_ items: [MemberByFollowItemDTO]) {
        self.snapshot.appendItems(items, toSection: .main)
        self.dataSource.applySnapshotUsingReloadData(self.snapshot)
    }
    
    private func loadMoreFollowers(_ items: [MemberByFollowItemDTO]) {
        self.snapshot.appendItems(items, toSection: .main)
        self.dataSource.applySnapshotUsingReloadData(self.snapshot)
    }
    
    private func updateFollower(memberId: Int) {
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
    
    private func deleteFollower(memberId: Int) {
        for item in snapshot.itemIdentifiers {
            if item.memberId == memberId {
                self.snapshot.deleteItems([item])
                self.dataSource.apply(self.snapshot)
                return
            }
        }
    }
}
