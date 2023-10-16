//
//  FindViewController.swift
//  FoodBowl
//
//  Created by COBY_PRO on 2023/07/24.
//

import UIKit

import SnapKit
import Then

final class FindViewController: BaseViewController {
    private var viewModel = FindViewModel()

    private enum Size {
        static let cellWidth: CGFloat = (BaseSize.fullWidth - 16) / 3
        static let cellHeight: CGFloat = cellWidth
        static let collectionInset = UIEdgeInsets(
            top: 0,
            left: 20,
            bottom: 20,
            right: 20
        )
    }

    private lazy var isBookmarked = [Bool](repeating: false, count: 10)

    private var stores: [StoreBySearch] = [] {
        didSet {
            DispatchQueue.main.async {
                self.findResultViewController.searchResultTableView.reloadData()
            }
        }
    }

    private var members: [MemberBySearch] = [] {
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

    // MARK: - property
    private var refreshControl = UIRefreshControl()

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

    override func viewDidLoad() {
        super.viewDidLoad()
        setupRefreshControl()
    }

    override func setupLayout() {
        view.addSubviews(listCollectionView)

        listCollectionView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }

    override func setupNavigationBar() {
        super.setupNavigationBar()
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

    override func loadData() {
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
            stores.count
        } else {
            members.count
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

            cell.setupData(stores[indexPath.item])
            cell.selectionStyle = .none

            return cell
        } else {
            guard let cell = tableView.dequeueReusableCell(
                withIdentifier: UserInfoTableViewCell.className,
                for: indexPath
            ) as? UserInfoTableViewCell else {
                return UITableViewCell()
            }

            cell.setupData(members[indexPath.item])
            cell.selectionStyle = .none

            return cell
        }
    }

    func tableView(_: UITableView, heightForRowAt _: IndexPath) -> CGFloat {
        return 64
    }

    func tableView(_: UITableView, didSelectRowAt indexPath: IndexPath) {
        if scope == 0 {
            let storeDetailViewController = StoreDetailViewController(storeId: stores[indexPath.item].storeId)
            storeDetailViewController.title = stores[indexPath.item].storeName
            DispatchQueue.main.async { [weak self] in
                self?.navigationController?.pushViewController(storeDetailViewController, animated: true)
            }
        } else {
            let profileViewController = ProfileViewController(isOwn: false, memberId: members[indexPath.item].memberId)
            DispatchQueue.main.async { [weak self] in
                self?.navigationController?.pushViewController(profileViewController, animated: true)
            }
        }
    }
}
