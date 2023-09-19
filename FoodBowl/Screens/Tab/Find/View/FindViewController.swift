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
    private enum Size {
        static let collectionInset = UIEdgeInsets(
            top: 0,
            left: 0,
            bottom: 10,
            right: 0
        )
    }

    private lazy var isBookmarked = [Bool](repeating: false, count: 10)

    private var stores = [Place]()
    private var users = [MemberProfileResponse]()
    private var scope: Int = 0

    // MARK: - property
    private var refreshControl = UIRefreshControl()

    private let findGuideLabel = PaddingLabel().then {
        $0.font = .font(.regular, ofSize: 22)
        $0.text = "찾기"
        $0.textColor = .mainText
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

    private let collectionViewFlowLayout = DynamicHeightCollectionViewFlowLayout().then {
        $0.sectionInset = Size.collectionInset
        $0.minimumLineSpacing = 20
        $0.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
    }

    private lazy var listCollectionView = UICollectionView(frame: .zero, collectionViewLayout: collectionViewFlowLayout).then {
        $0.dataSource = self
        $0.delegate = self
        $0.showsVerticalScrollIndicator = false
        $0.register(FeedCollectionViewCell.self, forCellWithReuseIdentifier: FeedCollectionViewCell.className)
        $0.backgroundColor = .mainBackground
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

    private func loadData() {}
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
        print(text)
    }

    func searchBar(_ searchBar: UISearchBar, selectedScopeButtonIndexDidChange selectedScope: Int) {
        scope = selectedScope
        findResultViewController.searchResultTableView.reloadData()
    }
}

// MARK: - UICollectionViewDataSource, UICollectionViewDelegate
extension FindViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_: UICollectionView, numberOfItemsInSection _: Int) -> Int {
        return 10
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: FeedCollectionViewCell.className,
            for: indexPath
        ) as? FeedCollectionViewCell else {
            return UICollectionViewCell()
        }

        cell.userButtonTapAction = { [weak self] _ in
            let profileViewController = ProfileViewController(isOwn: false)
            self?.navigationController?.pushViewController(profileViewController, animated: true)
        }

        cell.optionButtonTapAction = { [weak self] _ in
            let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)

            let edit = UIAlertAction(title: "수정", style: .default, handler: { _ in
                let viewModel = UpdateReviewViewModel()
                let updateReviewViewController = UpdateReviewViewController(viewModel: viewModel)
                let navigationController = UINavigationController(rootViewController: updateReviewViewController)
                DispatchQueue.main.async {
                    self?.present(navigationController, animated: true)
                }
            })

            let report = UIAlertAction(title: "신고", style: .destructive, handler: { _ in
                self?.sendReportMail()
            })
            let cancel = UIAlertAction(title: "취소", style: .cancel, handler: nil)

            alert.addAction(edit)
            alert.addAction(cancel)
            alert.addAction(report)

            self?.present(alert, animated: true, completion: nil)
        }

        cell.followButtonTapAction = { _ in
            cell.userInfoView.followButton.isSelected.toggle()
        }

        cell.storeButtonTapAction = { [weak self] _ in
            let storeDetailViewController = StoreDetailViewController()
            storeDetailViewController.title = "틈새라면"
            self?.navigationController?.pushViewController(storeDetailViewController, animated: true)
        }

        cell.bookmarkButtonTapAction = { [weak self] _ in
            self?.isBookmarked[indexPath.item].toggle()
            cell.storeInfoView.bookmarkButton.isSelected.toggle()
        }
        cell.storeInfoView.bookmarkButton.isSelected = isBookmarked[indexPath.item]

        return cell
    }
}

extension FindViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_: UITableView, numberOfRowsInSection _: Int) -> Int {
        return 5
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if scope == 0 {
            guard let cell = tableView
                .dequeueReusableCell(withIdentifier: StoreInfoTableViewCell.className, for: indexPath) as? StoreInfoTableViewCell
            else { return UITableViewCell() }

            cell.storeNameLabel.text = "가게이름"
            cell.storeFeedLabel.text = "100명이 후기를 남겼습니다."
            cell.storeDistanceLabel.text = "10km"
            cell.selectionStyle = .none

            return cell
        } else {
            guard let cell = tableView
                .dequeueReusableCell(withIdentifier: UserInfoTableViewCell.className, for: indexPath) as? UserInfoTableViewCell
            else { return UITableViewCell() }

            cell.followButtonTapAction = { _ in
                cell.followButton.isSelected.toggle()
            }
            cell.selectionStyle = .none

            return cell
        }
    }

    func tableView(_: UITableView, heightForRowAt _: IndexPath) -> CGFloat {
        return 64
    }

    func tableView(_: UITableView, didSelectRowAt _: IndexPath) {
        if scope == 0 {
            let storeDetailViewController = StoreDetailViewController()
            storeDetailViewController.title = "틈새라면"
            DispatchQueue.main.async { [weak self] in
                self?.navigationController?.pushViewController(storeDetailViewController, animated: true)
            }
        } else {
            let profileViewController = ProfileViewController(isOwn: false)
            profileViewController.title = "초코비"
            DispatchQueue.main.async { [weak self] in
                self?.navigationController?.pushViewController(profileViewController, animated: true)
            }
        }
    }
}
