//
//  StoreDeatilView.swift
//  FoodBowl
//
//  Created by COBY_PRO on 10/20/23.
//

import Combine
import UIKit

import SnapKit
import Then

protocol StoreDetailViewDelegate: AnyObject {
//    func didTapAppleSignButton()
}

final class StoreDeatilView: UIView, BaseViewType {
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
    
    private var refreshControl = UIRefreshControl()
    private var isLoadingData = false

    private lazy var reviewToggleButton = ReviewToggleButton().then {
        let action = UIAction { [weak self] _ in
//            self?.reviewToggleButtonTapped()
        }
        $0.addAction(action, for: .touchUpInside)
        $0.isSelected = self.isFriend
    }
    private var storeHeaderView = StoreHeaderView()
    private lazy var listCollectionView = UICollectionView(frame: .zero, collectionViewLayout: self.createLayout()).then {
        $0.showsVerticalScrollIndicator = false
        $0.register(FeedNSCollectionViewCell.self, forCellWithReuseIdentifier: FeedNSCollectionViewCell.className)
        $0.backgroundColor = .mainBackgroundColor
    }
    
    // MARK: - property
    
    private let storeId: Int
    var isFriend: Bool
    var title: String
    
    private weak var delegate: StoreDetailViewDelegate?
    private var cancelBag: Set<AnyCancellable> = Set()
    
    // MARK: - init
    
    init(storeId: Int, isFriend: Bool = true) {
        self.storeId = storeId
        self.isFriend = isFriend
        self.title = isFriend ? "친구들의 후기" : "모두의 후기"
        super.init(frame: .zero)
        self.baseInit()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - func

    func configureNavigationBar(of viewController: UIViewController) {
        self.setupNavigationTitle(in: viewController)
        self.setupNavigationItem(in: viewController)
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

    // MARK: - func

    private func bindUI() {
    }

    private func setupNavigationTitle(in viewController: UIViewController) {
        guard let navigationController = viewController.navigationController else { return }
        navigationController.title = title
    }
    
    private func setupNavigationItem(in viewController: UIViewController) {
        guard let navigationController = viewController.navigationController else { return }
        let reviewToggleButton = navigationController.makeBarButtonItem(with: reviewToggleButton)
        navigationController.navigationItem.rightBarButtonItem = reviewToggleButton
    }
}

// MARK: - UICollectionViewLayout
extension StoreDeatilView {
    private func createLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewCompositionalLayout { [weak self] index, environment -> NSCollectionLayoutSection? in
            let itmeSize = NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1),
                heightDimension: .estimated(200)
            )
            
            let item = NSCollectionLayoutItem(layoutSize: itmeSize)
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
