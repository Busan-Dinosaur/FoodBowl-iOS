//
//  SetCategoryViewController.swift
//  FoodBowl
//
//  Created by COBY_PRO on 2023/01/10.
//

import UIKit

import SnapKit
import Then

final class SetCategoryViewController: BaseViewController {
    var delegate: SetCategoryViewControllerDelegate?
    private let categories = Category.allCases

    // MARK: - property

    private let guideLabel = UILabel().then {
        $0.text = "음식의 카테고리를 선택해주세요."
        $0.font = UIFont.preferredFont(forTextStyle: .title3, weight: .medium)
        $0.textColor = .mainText
    }

    private lazy var listCollectionView = UICollectionView(frame: .zero, collectionViewLayout: createTagLayout()).then {
        $0.dataSource = self
        $0.delegate = self
        $0.showsHorizontalScrollIndicator = false
        $0.showsVerticalScrollIndicator = false
        $0.allowsMultipleSelection = true
        $0.register(CategoryCollectionViewCell.self, forCellWithReuseIdentifier: CategoryCollectionViewCell.className)
        $0.backgroundColor = .clear
    }

    // MARK: - life cycle

    override func render() {
        view.addSubviews(guideLabel, listCollectionView)

        guideLabel.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top).inset(20)
            $0.leading.equalToSuperview().inset(20)
        }

        listCollectionView.snp.makeConstraints {
            $0.top.equalTo(guideLabel.snp.bottom).offset(20)
            $0.leading.trailing.bottom.equalToSuperview()
        }
    }

    private func createTagLayout() -> UICollectionViewLayout {
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .estimated(80),
            heightDimension: .absolute(40)
        )

        let item = NSCollectionLayoutItem(layoutSize: itemSize)

        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .absolute(40)
        )

        let group = NSCollectionLayoutGroup.horizontal(
            layoutSize: groupSize,
            subitems: [item]
        )
        group.interItemSpacing = .fixed(10)

        let section = NSCollectionLayoutSection(group: group)
        section.interGroupSpacing = 10
        section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 20, bottom: 20, trailing: 20)

        let config = UICollectionViewCompositionalLayoutConfiguration()
        config.scrollDirection = .vertical

        let layout = UICollectionViewCompositionalLayout(section: section)
        layout.configuration = config
        return layout
    }
}

// MARK: - UICollectionViewDataSource, UICollectionViewDelegate

extension SetCategoryViewController: UICollectionViewDataSource, UICollectionViewDelegate {
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

    func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt _: IndexPath) -> Bool {
        return collectionView.indexPathsForSelectedItems?.count ?? 0 <= 2
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt _: IndexPath) {
        guard let selectedItems = collectionView.indexPathsForSelectedItems else { return }
        let selectedCategories: [Category]? = selectedItems.map { categories[$0.item] }
        delegate?.setCategories(categories: selectedCategories)
    }

    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt _: IndexPath) {
        guard let selectedItems = collectionView.indexPathsForSelectedItems else { return }
        let selectedCategories: [Category]? = selectedItems.map { categories[$0.item] }
        delegate?.setCategories(categories: selectedCategories)
    }
}

protocol SetCategoryViewControllerDelegate: AnyObject {
    func setCategories(categories: [Category]?)
}
