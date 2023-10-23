//
//  FeedListView.swift
//  FoodBowl
//
//  Created by COBY_PRO on 2023/07/22.
//

import Combine
import UIKit

import SnapKit
import Then

final class FeedListView: UIView, BaseViewType {
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
    let borderLineView = UIView().then {
        $0.backgroundColor = .grey002.withAlphaComponent(0.5)
    }
    lazy var listCollectionView = UICollectionView(frame: .zero, collectionViewLayout: self.createLayout()).then {
        $0.showsVerticalScrollIndicator = false
        $0.register(FeedNSCollectionViewCell.self, forCellWithReuseIdentifier: FeedNSCollectionViewCell.className)
        $0.backgroundColor = .mainBackgroundColor
    }
    
    // MARK: - property
    
    private var cancelBag: Set<AnyCancellable> = Set()
    
    let refreshPublisher = PassthroughSubject<Void, Never>()

    // MARK: - init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupLayout()
        configureUI()
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - func
    
    func collectionView() -> UICollectionView {
        return self.listCollectionView
    }
    
    // MARK: - base func
    
    func setupLayout() {
        addSubviews(borderLineView, listCollectionView)

        borderLineView.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview()
            $0.height.equalTo(1)
        }

        listCollectionView.snp.makeConstraints {
            $0.top.equalTo(borderLineView.snp.bottom)
            $0.leading.trailing.bottom.equalToSuperview()
        }
    }

    func configureUI() {
        backgroundColor = .mainBackgroundColor
    }
    
    // MARK: - Private - func

    private func setupAction() {
        let refreshAction = UIAction { [weak self] _ in
            self?.refreshPublisher.send()
        }
        self.refreshControl.addAction(refreshAction, for: .valueChanged)
        self.refreshControl.tintColor = .grey002
        self.listCollectionView.refreshControl = self.refreshControl
    }
}

// MARK: - UICollectionViewLayout
extension FeedListView {
    private func createLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewCompositionalLayout { index, environment -> NSCollectionLayoutSection? in
            let itmeSize = NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1),
                heightDimension: .estimated(250)
            )
            
            let item = NSCollectionLayoutItem(layoutSize: itmeSize)
            item.contentInsets = ConstantSize.sectionContentInset
            
            let groupSize = NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1),
                heightDimension: .estimated(250)
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
