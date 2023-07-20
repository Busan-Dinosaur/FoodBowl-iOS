//
//  MapHeaderView.swift
//  FoodBowl
//
//  Created by COBY_PRO on 2023/07/21.
//

import UIKit

import SnapKit
import Then

final class MapHeaderView: UIView {
    enum Size {
        static let SearchBarWidth: CGFloat = BaseSize.fullWidth - BaseSize.leadingTrailingPadding - 30
    }

    private let categories = Category.allCases

    // MARK: - property
    lazy var searchBarButton = SearchBarButton().then {
        $0.label.text = "새로운 맛집과 유저를 찾아보세요."
    }

    let plusButton = PlusButton()

    private let collectionViewFlowLayout = UICollectionViewFlowLayout().then {
        $0.scrollDirection = .horizontal
        $0.sectionInset = BaseSize.collectionInset
        $0.minimumLineSpacing = 8
        $0.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
    }

    private lazy var listCollectionView = UICollectionView(frame: .zero, collectionViewLayout: collectionViewFlowLayout).then {
        $0.backgroundColor = .clear
        $0.dataSource = self
        $0.delegate = self
        $0.showsHorizontalScrollIndicator = false
        $0.allowsMultipleSelection = true
        $0.register(CategoryCollectionViewCell.self, forCellWithReuseIdentifier: CategoryCollectionViewCell.className)
    }

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

    // MARK: - life cycle
    private func setupLayout() {
        addSubviews(searchBarButton, plusButton, listCollectionView)

        searchBarButton.snp.makeConstraints {
            $0.top.equalTo(safeAreaLayoutGuide).inset(10)
            $0.leading.equalToSuperview().inset(BaseSize.leadingTrailingPadding)
            $0.width.equalTo(Size.SearchBarWidth)
            $0.height.equalTo(50)
        }

        plusButton.snp.makeConstraints {
            $0.centerY.equalTo(searchBarButton)
            $0.leading.equalTo(searchBarButton.snp.trailing).offset(BaseSize.leadingTrailingPadding)
            $0.trailing.equalToSuperview().inset(BaseSize.leadingTrailingPadding)
            $0.width.height.equalTo(30)
        }

        listCollectionView.snp.makeConstraints {
            $0.top.equalTo(searchBarButton.snp.bottom).offset(10)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(40)
        }
    }

    private func configureUI() {
        backgroundColor = .mainBackground
    }
}

// MARK: - UICollectionViewDataSource, UICollectionViewDelegate
extension MapHeaderView: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_: UICollectionView, numberOfItemsInSection _: Int) -> Int {
        return categories.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: CategoryCollectionViewCell.className,
            for: indexPath
        ) as? CategoryCollectionViewCell else {
            return UICollectionViewCell()
        }

        cell.layer.cornerRadius = 20
        cell.categoryLabel.text = categories[indexPath.item].rawValue

        return cell
    }

    func collectionView(_: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print(categories[indexPath.item].rawValue)
    }
}
