//
//  FindView.swift
//  FoodBowl
//
//  Created by Coby on 1/19/24.
//

import Combine
import UIKit

import SnapKit
import Then

final class FindView: UIView, BaseViewType {
    
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
    
    private let plusButton = PlusButton()
    private let findGuideLabel = PaddingLabel().then {
        $0.font = .font(.regular, ofSize: 22)
        $0.text = "찾기"
        $0.textColor = .mainTextColor
        $0.padding = UIEdgeInsets(top: 0, left: 4, bottom: 0, right: 0)
        $0.frame = CGRect(x: 0, y: 0, width: 150, height: 0)
    }
    private let findResultViewController = FindResultViewController()
    private lazy var searchController = UISearchController(searchResultsController: self.findResultViewController).then {
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
    lazy var listCollectionView = UICollectionView(frame: .zero, collectionViewLayout: collectionViewFlowLayout).then {
        $0.backgroundColor = .clear
        $0.showsVerticalScrollIndicator = false
        $0.register(PhotoCollectionViewCell.self, forCellWithReuseIdentifier: PhotoCollectionViewCell.className)
    }
    
    // MARK: - property
    
    var stores: [Store] = []
    var members: [Member] = []
    private var scope: Int = 0
    private var searchText: String = ""
    private var refreshControl = UIRefreshControl()
    
    var plusButtonDidTapPublisher: AnyPublisher<Void, Never> {
        return self.plusButton.buttonTapPublisher
    }
    let searchStoresPublisher = PassthroughSubject<String, Never>()
    
    // MARK: - init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.baseInit()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - func
    
    func configureNavigationBarItem(_ navigationController: UINavigationController) {
        let navigationItem = navigationController.topViewController?.navigationItem
        let findGuideLabel = navigationController.makeBarButtonItem(with: findGuideLabel)
        let plusButton = navigationController.makeBarButtonItem(with: plusButton)
        navigationItem?.leftBarButtonItem = findGuideLabel
        navigationItem?.rightBarButtonItem = plusButton
        navigationItem?.searchController = self.searchController
    }
    
    // MARK: - base func
    
    func setupLayout() {
        self.addSubviews(self.listCollectionView)

        self.listCollectionView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    func configureUI() {
        self.backgroundColor = .mainBackgroundColor
    }
}

extension FindView: UISearchResultsUpdating, UISearchBarDelegate {
    func updateSearchResults(for searchController: UISearchController) {
        guard let text = searchController.searchBar.text?.lowercased() else { return }
        self.searchText = text
    }

    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        self.searchController.searchBar.showsScopeBar = true
    }

    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        self.searchController.searchBar.showsScopeBar = false
    }

    func searchBar(_ searchBar: UISearchBar, selectedScopeButtonIndexDidChange selectedScope: Int) {
        self.scope = selectedScope
        self.findResultViewController.searchResultTableView.reloadData()
    }
}
