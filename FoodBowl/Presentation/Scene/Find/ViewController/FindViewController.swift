//
//  FindViewController.swift
//  FoodBowl
//
//  Created by COBY_PRO on 2023/07/24.
//

import UIKit

import SnapKit
import Then

final class FindViewController: UIViewController, Navigationable, Keyboardable {
    
    private enum Size {
        static let cellWidth: CGFloat = (SizeLiteral.fullWidth - 16) / 3
        static let cellHeight: CGFloat = cellWidth
        static let collectionInset = UIEdgeInsets(
            top: 0,
            left: 20,
            bottom: 20,
            right: 20
        )
    }
    
    // MARK: - ui component
    
    lazy var plusButton = PlusButton().then {
        let action = UIAction { [weak self] _ in
            let repository = CreateReviewRepositoryImpl()
            let usecase = CreateReviewUsecaseImpl(repository: repository)
            let viewModel = CreateReviewViewModel(usecase: usecase)
            let viewController = CreateReviewViewController(viewModel: viewModel)
            let navigationController = UINavigationController(rootViewController: viewController)
            navigationController.modalPresentationStyle = .fullScreen
            
            DispatchQueue.main.async {
                self?.present(navigationController, animated: true)
            }
            
            viewController.delegate = self
        }
        $0.addAction(action, for: .touchUpInside)
    }
    private let findGuideLabel = PaddingLabel().then {
        $0.font = .font(.regular, ofSize: 22)
        $0.text = "찾기"
        $0.textColor = .mainTextColor
        $0.padding = UIEdgeInsets(top: 0, left: 4, bottom: 0, right: 0)
        $0.frame = CGRect(x: 0, y: 0, width: 150, height: 0)
    }
    private lazy var findResultViewController = FindResultViewController().then {
        $0.searchResultTableView.delegate = self
        $0.searchResultTableView.dataSource = self
    }
    private lazy var searchController = UISearchController(searchResultsController: findResultViewController).then {
        $0.searchResultsUpdater = self
        $0.searchBar.delegate = self
        $0.searchBar.placeholder = "검색"
        $0.searchBar.setValue("취소", forKey: "cancelButtonText")
        $0.searchBar.tintColor = .mainPink
        $0.searchBar.scopeButtonTitles = ["맛집", "유저"]
        $0.obscuresBackgroundDuringPresentation = true
        $0.searchBar.showsScopeBar = false
        $0.searchBar.sizeToFit()
    }
    private let collectionViewFlowLayout = UICollectionViewFlowLayout().then {
        $0.scrollDirection = .vertical
        $0.sectionInset = Size.collectionInset
        $0.itemSize = CGSize(width: Size.cellWidth, height: Size.cellHeight)
        $0.minimumLineSpacing = 8
        $0.minimumInteritemSpacing = 8
    }
    private lazy var listCollectionView = UICollectionView(frame: .zero, collectionViewLayout: collectionViewFlowLayout).then {
        $0.backgroundColor = .clear
        $0.dataSource = self
        $0.delegate = self
        $0.showsVerticalScrollIndicator = false
        $0.register(PhotoCollectionViewCell.self, forCellWithReuseIdentifier: PhotoCollectionViewCell.className)
    }
    
    // MARK: - property
    
    private var viewModel = MapViewModel()
    private lazy var isBookmarked = [Bool](repeating: false, count: 10)
    private var stores: [StoreItemBySearchDTO] = [] {
        didSet {
            DispatchQueue.main.async {
                self.findResultViewController.searchResultTableView.reloadData()
            }
        }
    }
    private var members: [MemberDTO] = [] {
        didSet {
            DispatchQueue.main.async {
                self.findResultViewController.searchResultTableView.reloadData()
            }
        }
    }
    private var scope: Int = 0 {
        didSet {
            loadData()
        }
    }
    private var searchText: String = "" {
        didSet {
            loadData()
        }
    }    
    private var refreshControl = UIRefreshControl()
    
    // MARK: - life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupNavigation()
        self.setupLayout()
        self.configureUI()
        self.setupRefreshControl()
    }

    func setupLayout() {
        view.addSubviews(listCollectionView)

        listCollectionView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    func configureUI() {
        view.backgroundColor = .mainBackgroundColor
    }

    func setupNavigation() {
        let findGuideLabel = makeBarButtonItem(with: findGuideLabel)
        let plusButton = makeBarButtonItem(with: plusButton)
        navigationItem.leftBarButtonItem = findGuideLabel
        navigationItem.rightBarButtonItem = plusButton
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
    }

    private func setupRefreshControl() {
        let action = UIAction { [weak self] _ in
            self?.loadData()
        }
        refreshControl.addAction(action, for: .valueChanged)
        refreshControl.tintColor = .grey002
        listCollectionView.refreshControl = refreshControl
    }

    func loadData() {
        if searchText == "" {
            return
        }

        Task {
            if scope == 0 {
                stores = await viewModel.serachStores(name: searchText)
            } else {
                members = await viewModel.searchMembers(name: searchText)
            }
        }
    }
}

extension FindViewController {
    // Standard scroll-view delegate
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let contentSize = scrollView.contentSize.height

        if contentSize - scrollView.contentOffset.y <= scrollView.bounds.height {
            didScrollToBottom()
        }
    }

    private func didScrollToBottom() {}
}

extension FindViewController: UISearchResultsUpdating, UISearchBarDelegate {
    func updateSearchResults(for searchController: UISearchController) {
        guard let text = searchController.searchBar.text?.lowercased() else { return }
        searchText = text
    }

    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchController.searchBar.showsScopeBar = true
    }

    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        searchController.searchBar.showsScopeBar = false
    }

    func searchBar(_ searchBar: UISearchBar, selectedScopeButtonIndexDidChange selectedScope: Int) {
        scope = selectedScope
        findResultViewController.searchResultTableView.reloadData()
    }
}

extension FindViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_: UICollectionView, numberOfItemsInSection _: Int) -> Int {
        return 20
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: PhotoCollectionViewCell.className,
            for: indexPath
        ) as? PhotoCollectionViewCell else {
            return UICollectionViewCell()
        }

        return cell
    }

    func collectionView(_: UICollectionView, didSelectItemAt _: IndexPath) {
        let recentReviewController = RecentReviewController()
        DispatchQueue.main.async { [weak self] in
            self?.navigationController?.pushViewController(recentReviewController, animated: true)
        }
    }
}

extension FindViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_: UITableView, numberOfRowsInSection _: Int) -> Int {
        if scope == 0 {
            return stores.count
        } else {
            return members.count
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if scope == 0 {
            guard let cell = tableView.dequeueReusableCell(
                withIdentifier: StoreInfoTableViewCell.className,
                for: indexPath
            ) as? StoreInfoTableViewCell else {
                return UITableViewCell()
            }

            cell.selectionStyle = .none
            cell.setupData(stores[indexPath.item])

            return cell
        } else {
            guard let cell = tableView.dequeueReusableCell(
                withIdentifier: UserInfoTableViewCell.className,
                for: indexPath
            ) as? UserInfoTableViewCell else {
                return UITableViewCell()
            }

            let member = members[indexPath.item]

            cell.selectionStyle = .none
            cell.setupData(member)

            if member.isMe {
                cell.followButton.isHidden = true
            } else {
                cell.followButton.isHidden = false
                cell.followButton.isSelected = member.isFollowing
                cell.followButtonTapAction = { [weak self] _ in
                    Task {
                        guard let self = self else { return }
                        Task {
                            if cell.followButton.isSelected {
                                cell.followButton.isSelected = await self.viewModel.unfollowMember(memberId: member.memberId)
                            } else {
                                cell.followButton.isSelected = await self.viewModel.followMember(memberId: member.memberId)
                            }
                        }
                    }
                }
            }

            return cell
        }
    }

    func tableView(_: UITableView, heightForRowAt _: IndexPath) -> CGFloat {
        return 64
    }

    func tableView(_: UITableView, didSelectRowAt indexPath: IndexPath) {
        if scope == 0 {
            let repository = StoreDetailRepositoryImpl()
            let usecase = StoreDetailUsecaseImpl(repository: repository)
            let viewModel = StoreDetailViewModel(storeId: stores[indexPath.item].storeId, isFriend: false, usecase: usecase)
            let viewController = StoreDetailViewController(viewModel: viewModel)

            DispatchQueue.main.async { [weak self] in
                self?.navigationController?.pushViewController(viewController, animated: true)
            }
        } else {
            let profileViewController = ProfileViewController(memberId: members[indexPath.item].memberId)
            DispatchQueue.main.async { [weak self] in
                self?.navigationController?.pushViewController(profileViewController, animated: true)
            }
        }
    }
}

extension FindViewController: CreateReviewControllerDelegate {
    func updateData() {
        loadData()
    }
}
