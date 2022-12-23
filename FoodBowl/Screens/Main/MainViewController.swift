//
//  MainViewController.swift
//  FoodBowl
//
//  Created by COBY_PRO on 2022/12/23.
//

import UIKit

import SnapKit
import Then

final class MainViewController: BaseViewController {
    private enum Size {
        static let cellWidth: CGFloat = UIScreen.main.bounds.size.width
        static let cellHeight: CGFloat = cellWidth * 1.35
        static let collectionInset = UIEdgeInsets(top: 0,
                                                  left: 0,
                                                  bottom: 20,
                                                  right: 0)
    }

    private var refreshControl = UIRefreshControl()

    private var selectedRegions: [String] = ["전체"]

    // MARK: - property

    private lazy var regionTagButton = UIButton().then {
        $0.tintColor = .black
        $0.setTitle("전체 ", for: .normal)
        $0.setTitleColor(.black, for: .normal)
        $0.titleLabel?.font = .preferredFont(forTextStyle: .title3, weight: .medium)
        $0.setImage(ImageLiteral.btnDown, for: .normal)
        $0.semanticContentAttribute = .forceRightToLeft
        let action = UIAction { [weak self] _ in
            let regionViewController = RegionViewController()
            regionViewController.modalPresentationStyle = .pageSheet
            regionViewController.sheetPresentationController?.detents = [.medium()]
            regionViewController.delegate = self

            self?.present(regionViewController, animated: true, completion: nil)
        }
        $0.addAction(action, for: .touchUpInside)
    }

    private let collectionViewFlowLayout = UICollectionViewFlowLayout().then {
        $0.scrollDirection = .vertical
        $0.sectionInset = Size.collectionInset
        $0.itemSize = CGSize(width: Size.cellWidth, height: Size.cellHeight)
        $0.minimumLineSpacing = 10
    }

    private lazy var listCollectionView = UICollectionView(frame: .zero, collectionViewLayout: collectionViewFlowLayout).then {
        $0.backgroundColor = .white
        $0.dataSource = self
        $0.delegate = self
        $0.showsVerticalScrollIndicator = false
        $0.register(FeedCollectionViewCell.self, forCellWithReuseIdentifier: FeedCollectionViewCell.className)
    }

    private let emptyFeedView = EmptyFeedView()

    // MARK: - life cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setupRefreshControl()
        loadData()
    }

    override func render() {
        view.addSubviews(listCollectionView)

        listCollectionView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }

    override func setupNavigationBar() {
        super.setupNavigationBar()

        let regionTagView = makeBarButtonItem(with: regionTagButton)
        navigationItem.leftBarButtonItem = regionTagView
    }

    private func setupRefreshControl() {
        let action = UIAction { [weak self] _ in
            self?.loadData()
        }
        refreshControl.addAction(action, for: .valueChanged)
        refreshControl.tintColor = .lightGray
        listCollectionView.refreshControl = refreshControl
    }

    private func loadData() {
        guard let regions = UserDefaults.standard.stringArray(forKey: "regions") else { return }
        selectedRegions = regions

        if selectedRegions.isEmpty {
            selectedRegions = ["전체"]
        }
        let count = selectedRegions.count == 1 ? "" : "외 \(selectedRegions.count - 1)곳"
        regionTagButton.setTitle("\(selectedRegions[0]) \(count) ", for: .normal)
    }
}

// MARK: - UICollectionViewDataSource, UICollectionViewDelegate

extension MainViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_: UICollectionView, numberOfItemsInSection _: Int) -> Int {
        return 10
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FeedCollectionViewCell.className, for: indexPath) as? FeedCollectionViewCell else {
            return UICollectionViewCell()
        }

        return cell
    }

    func collectionView(_: UICollectionView, didSelectItemAt _: IndexPath) {}
}

extension MainViewController {
    /* Standard scroll-view delegate */
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let contentSize = scrollView.contentSize.height

        if contentSize - scrollView.contentOffset.y <= scrollView.bounds.height {
            didScrollToBottom()
        }
    }

    private func didScrollToBottom() {}
}

protocol RegionViewControllerDelegate: AnyObject {
    func dismissRegionViewController()
}

extension MainViewController: RegionViewControllerDelegate {
    func dismissRegionViewController() {
        print("닫힘")
        loadData()
    }
}
