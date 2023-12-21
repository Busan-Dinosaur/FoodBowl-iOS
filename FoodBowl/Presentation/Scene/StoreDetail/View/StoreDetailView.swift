//
//  StoreDetailView.swift
//  FoodBowl
//
//  Created by COBY_PRO on 10/20/23.
//

import Combine
import UIKit

import SnapKit
import Then

final class StoreDetailView: UIView, BaseViewType {
    
    private enum ConstantSize {
        static let sectionContentInset: NSDirectionalEdgeInsets = NSDirectionalEdgeInsets(
            top: 0,
            leading: 0,
            bottom: SizeLiteral.verticalPadding,
            trailing: 0
        )
        static let groupInterItemSpacing: CGFloat = 20
    }
    
    // MARK: - ui component
    
    var refreshControl = UIRefreshControl()

    private lazy var reviewToggleButton = ReviewToggleButton().then {
        $0.isSelected = self.isFriend
    }
    private var storeHeaderView = StoreHeaderView()
    lazy var listCollectionView = UICollectionView(frame: .zero, collectionViewLayout: self.createLayout()).then {
        $0.showsVerticalScrollIndicator = false
        $0.register(FeedNSCollectionViewCell.self, forCellWithReuseIdentifier: FeedNSCollectionViewCell.className)
        $0.backgroundColor = .mainBackgroundColor
    }
    
    // MARK: - property
    
    private let storeId: Int
    private var isFriend: Bool

    private var cancelBag: Set<AnyCancellable> = Set()
    
    let reviewToggleButtonDidTapPublisher = PassthroughSubject<Bool, Never>()
    let refreshPublisher = PassthroughSubject<Void, Never>()
    
    // MARK: - init
    
    init(storeId: Int, isFriend: Bool = true) {
        self.storeId = storeId
        self.isFriend = isFriend
        super.init(frame: .zero)
        self.baseInit()
        self.setupAction()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - func
    
    func configureNavigationBarItem(_ navigationController: UINavigationController) {        
        let navigationItem = navigationController.topViewController?.navigationItem
        let reviewToggleButton = navigationController.makeBarButtonItem(with: reviewToggleButton)
        navigationItem?.rightBarButtonItem = reviewToggleButton
    }
    
    func configureNavigationBarTitle(_ navigationController: UINavigationController) {
        let navigationItem = navigationController.topViewController?.navigationItem
        navigationItem?.title = isFriend ? "친구들의 후기" : "모두의 후기"
    }
    
    func collectionView() -> UICollectionView {
        return self.listCollectionView
    }
    
    // MARK: - base func
    
    func setupLayout() {
        self.addSubviews(storeHeaderView, listCollectionView)

        storeHeaderView.snp.makeConstraints {
            $0.top.equalTo(self.safeAreaLayoutGuide)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(50)
        }

        listCollectionView.snp.makeConstraints {
            $0.top.equalTo(storeHeaderView.snp.bottom)
            $0.leading.trailing.bottom.equalToSuperview()
        }
    }
    
    func configureUI() {
        self.backgroundColor = .mainBackgroundColor
    }
    
    // MARK: - Private - func

    private func setupAction() {
        let toggleAction = UIAction { [weak self] _ in
            guard let self = self else { return }
            self.isFriend.toggle()
            self.reviewToggleButton.isSelected = self.isFriend
            self.reviewToggleButtonDidTapPublisher.send(self.isFriend)
        }
        self.reviewToggleButton.addAction(toggleAction, for: .touchUpInside)
        
        let refreshAction = UIAction { [weak self] _ in
            self?.refreshPublisher.send()
        }
        self.refreshControl.addAction(refreshAction, for: .valueChanged)
        self.refreshControl.tintColor = .grey002
        self.listCollectionView.refreshControl = self.refreshControl
    }
}

// MARK: - UICollectionViewLayout
extension StoreDetailView {
    private func createLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewCompositionalLayout { index, environment -> NSCollectionLayoutSection? in
            let itemSize = NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1),
                heightDimension: .estimated(200)
            )
            
            let item = NSCollectionLayoutItem(layoutSize: itemSize)
            item.contentInsets = ConstantSize.sectionContentInset
            
            let groupSize = NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1),
                heightDimension: .estimated(200)
            )
            
            let group = NSCollectionLayoutGroup.horizontal(
                layoutSize: groupSize,
                subitems: [item]
            )
            
            let section = NSCollectionLayoutSection(group: group)
            section.interGroupSpacing = ConstantSize.groupInterItemSpacing
            
            return section
        }

        return layout
    }
}
