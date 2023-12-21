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
    private enum Size {
        static let collectionInset = UIEdgeInsets(
            top: 10,
            left: 0,
            bottom: 10,
            right: 0
        )
    }
    
    // MARK: - ui component
    
    var refreshControl = UIRefreshControl()
    
    let borderLineView = UIView().then {
        $0.backgroundColor = .grey002.withAlphaComponent(0.5)
    }
    lazy var collectionViewFlowLayout = DynamicHeightCollectionViewFlowLayout().then {
        $0.sectionInset = Size.collectionInset
        $0.minimumLineSpacing = 20
        $0.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
    }
    lazy var listCollectionView = UICollectionView(frame: .zero, collectionViewLayout: collectionViewFlowLayout).then {
        $0.showsVerticalScrollIndicator = false
        $0.register(FeedCollectionViewCell.self, forCellWithReuseIdentifier: FeedCollectionViewCell.className)
        $0.backgroundColor = .mainBackgroundColor
    }
    
    // MARK: - property
    
    private var cancelBag: Set<AnyCancellable> = Set()
    
    let refreshPublisher = PassthroughSubject<Void, Never>()

    // MARK: - init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        baseInit()
        setupAction()
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
