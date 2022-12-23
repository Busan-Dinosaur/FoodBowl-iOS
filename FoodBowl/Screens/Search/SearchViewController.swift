//
//  SearchViewController.swift
//  FoodBowl
//
//  Created by COBY_PRO on 2022/12/23.
//

import UIKit

import SnapKit
import Then

final class SearchViewController: BaseViewController {
    private enum Size {
        static let cellWidth: CGFloat = (UIScreen.main.bounds.size.width - 8) / 3
        static let cellHeight: CGFloat = cellWidth
        static let collectionInset = UIEdgeInsets(top: 0,
                                                  left: 0,
                                                  bottom: 20,
                                                  right: 0)
    }

    private var feeds: [String] = ["가나", "다라", "마바", "사아", "자차"]
    private var filteredFeeds: [String] = []

    private var isFiltering: Bool {
        let searchController = navigationItem.searchController
        let isActive = searchController?.isActive ?? false
        let isSearchBarHasText = searchController?.searchBar.text?.isEmpty == false
        return isActive && isSearchBarHasText
    }

    // MARK: - property

    private let collectionViewFlowLayout = UICollectionViewFlowLayout().then {
        $0.scrollDirection = .vertical
        $0.sectionInset = Size.collectionInset
        $0.itemSize = CGSize(width: Size.cellWidth, height: Size.cellHeight)
        $0.minimumLineSpacing = 4
        $0.minimumInteritemSpacing = 4
    }

    private lazy var listCollectionView = UICollectionView(frame: .zero, collectionViewLayout: collectionViewFlowLayout).then {
        $0.backgroundColor = .clear
        $0.dataSource = self
        $0.delegate = self
        $0.showsVerticalScrollIndicator = false
        $0.register(FeedThumnailCollectionViewCell.self, forCellWithReuseIdentifier: FeedThumnailCollectionViewCell.className)
    }

    private let emptyThumnailView = EmptyFeedView()

    // MARK: - life cycle

    override func render() {
        view.addSubviews(listCollectionView)

        listCollectionView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }

    override func setupNavigationBar() {
        super.setupNavigationBar()

        let searchController = UISearchController(searchResultsController: nil)
        searchController.searchBar.placeholder = "후기를 검색하세요."
        searchController.searchResultsUpdater = self
        navigationItem.leftBarButtonItem = nil
        navigationItem.titleView = searchController.searchBar
    }
}

// MARK: - UICollectionViewDataSource, UICollectionViewDelegate

extension SearchViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_: UICollectionView, numberOfItemsInSection _: Int) -> Int {
        return isFiltering ? filteredFeeds.count : feeds.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FeedThumnailCollectionViewCell.className, for: indexPath) as? FeedThumnailCollectionViewCell else {
            return UICollectionViewCell()
        }

        let feed = isFiltering ? filteredFeeds[indexPath.item] : feeds[indexPath.item]

        return cell
    }

    func collectionView(_: UICollectionView, didSelectItemAt _: IndexPath) {}
}

extension SearchViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        guard let text = searchController.searchBar.text?.lowercased() else { return }
        filteredFeeds = feeds.filter { $0.lowercased().contains(text) }
        listCollectionView.reloadData()
    }
}
