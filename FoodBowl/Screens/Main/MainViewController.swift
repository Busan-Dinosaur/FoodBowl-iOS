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
        static let collectionInset = UIEdgeInsets(top: 0,
                                                  left: 0,
                                                  bottom: 20,
                                                  right: 0)
    }

    private var refreshControl = UIRefreshControl()

    // MARK: - property

    private let collectionViewFlowLayout = DynamicHeightCollectionViewFlowLayout().then {
        $0.sectionInset = Size.collectionInset
        $0.minimumLineSpacing = 20
        $0.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
    }

    private lazy var listCollectionView = UICollectionView(frame: .zero, collectionViewLayout: collectionViewFlowLayout).then {
        $0.dataSource = self
        $0.delegate = self
        $0.register(FeedCollectionViewCell.self, forCellWithReuseIdentifier: FeedCollectionViewCell.className)
    }

    private let emptyFeedView = EmptyFeedView()

    private let appLogoView = UILabel().then {
        $0.font = UIFont.preferredFont(forTextStyle: .title1, weight: .bold)
        $0.text = "FoodBowl"
    }

    private lazy var plusButton = PlusButton().then {
        let action = UIAction { [weak self] _ in
            let addFeedViewController = AddFeedViewController()
            let navigationController = UINavigationController(rootViewController: addFeedViewController)
            navigationController.modalPresentationStyle = .overFullScreen
            DispatchQueue.main.async {
                self?.present(navigationController,animated: true)
            }
        }
        $0.addAction(action, for: .touchUpInside)
    }

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

        let appLogoView = makeBarButtonItem(with: appLogoView)
        let plusButton = makeBarButtonItem(with: plusButton)
        navigationItem.leftBarButtonItem = appLogoView
        navigationItem.rightBarButtonItem = plusButton
    }

    private func setupRefreshControl() {
        let action = UIAction { [weak self] _ in
            self?.loadData()
        }
        refreshControl.addAction(action, for: .valueChanged)
        refreshControl.tintColor = .lightGray
        listCollectionView.refreshControl = refreshControl
    }

    private func loadData() {}
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

        cell.userInfoView.userImageView.image = ImageLiteral.food2
        cell.commentLabel.text = """
        이번에 학교 앞에 새로 생겼길래 가봤는데 너무 맛있었어요.
        이번에 학교 앞에 새로 생겼길래 가봤는데 너무 맛있었어요.
        이번에 학교 앞에 새로 생겼길래 가봤는데 너무 맛있었어요.
        """

        return cell
    }
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
