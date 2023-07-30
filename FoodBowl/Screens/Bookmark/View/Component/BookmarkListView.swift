//
//  BookmarkListView.swift
//  FoodBowl
//
//  Created by COBY_PRO on 2023/07/31.
//

import UIKit

import SnapKit
import Then

final class BookmarkListView: ModalView {
    private enum Size {
        static let collectionInset = UIEdgeInsets(
            top: 0,
            left: 20,
            bottom: 20,
            right: 20
        )
        static let cellWidth: CGFloat = (UIScreen.main.bounds.size.width - BaseSize.horizantalPadding * 2 - 10) / 2
        static let cellHeight: CGFloat = 64
    }

    private lazy var isBookmarked = [Bool](repeating: false, count: 10)

    override func setupProperty() {
        collectionViewFlowLayout = UICollectionViewFlowLayout().then {
            $0.sectionInset = Size.collectionInset
            $0.minimumLineSpacing = 10
            $0.minimumInteritemSpacing = 10
            $0.itemSize = CGSize(width: Size.cellWidth, height: Size.cellHeight)
        }

        listCollectionView = UICollectionView(frame: .zero, collectionViewLayout: collectionViewFlowLayout).then {
            $0.dataSource = self
            $0.delegate = self
            $0.showsVerticalScrollIndicator = false
            $0.register(BookmarkCollectionViewCell.self, forCellWithReuseIdentifier: BookmarkCollectionViewCell.className)
            $0.backgroundColor = .mainBackground
        }

        resultLabel.text = "4개의 맛집"
    }

    override func configureUI() {
        resultLabel.isHidden = true
        backgroundColor = .mainBackground
    }

    override func showContent() {
        listCollectionView.isHidden = false
        resultLabel.isHidden = true
    }

    override func showResult() {
        listCollectionView.isHidden = true
        resultLabel.isHidden = false
    }
}

extension BookmarkListView {
    // Standard scroll-view delegate
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let contentSize = scrollView.contentSize.height

        if contentSize - scrollView.contentOffset.y <= scrollView.bounds.height {
            didScrollToBottom()
        }
    }

    private func didScrollToBottom() {}
}

// MARK: - UICollectionViewDataSource, UICollectionViewDelegate
extension BookmarkListView: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_: UICollectionView, numberOfItemsInSection _: Int) -> Int {
        return 10
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: BookmarkCollectionViewCell.className,
            for: indexPath
        ) as? BookmarkCollectionViewCell else {
            return UICollectionViewCell()
        }

        return cell
    }
}
