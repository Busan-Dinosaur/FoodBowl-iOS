//
//  StoreFeedViewController.swift
//  FoodBowl
//
//  Created by COBY_PRO on 2023/01/18.
//

import UIKit

import SnapKit
import Then

final class StoreFeedViewController: BaseViewController {
    var isMap: Bool

    init(isMap: Bool) {
        self.isMap = isMap
        super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private enum Size {
        static let collectionInset = UIEdgeInsets(top: 0,
                                                  left: 0,
                                                  bottom: 20,
                                                  right: 0)
    }

    private var refreshControl = UIRefreshControl()

    // MARK: - property

    private lazy var closeButton = CloseButton().then {
        let action = UIAction { [weak self] _ in
            self?.dismiss(animated: true, completion: nil)
        }
        $0.addAction(action, for: .touchUpInside)
    }

    private let collectionViewFlowLayout = DynamicHeightCollectionViewFlowLayout().then {
        $0.sectionInset = Size.collectionInset
        $0.minimumLineSpacing = 20
        $0.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
    }

    private lazy var listCollectionView = UICollectionView(frame: .zero, collectionViewLayout: collectionViewFlowLayout).then {
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

        title = "틈새라면"
        if isMap {
            let closeButton = makeBarButtonItem(with: closeButton)
            navigationItem.leftBarButtonItem = closeButton
        }
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

extension StoreFeedViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_: UICollectionView, numberOfItemsInSection _: Int) -> Int {
        return 10
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FeedCollectionViewCell.className, for: indexPath) as? FeedCollectionViewCell else {
            return UICollectionViewCell()
        }

        let userButtonAction = UIAction { [weak self] _ in
            let profileViewController = ProfileViewController(isOwn: false)
            self?.navigationController?.pushViewController(profileViewController, animated: true)
        }

        let mapButtonAction = UIAction { [weak self] _ in
            let showStoreInfoViewController = ShowStoreInfoViewController()
            showStoreInfoViewController.url = ""
            let navigationController = UINavigationController(rootViewController: showStoreInfoViewController)
            navigationController.modalPresentationStyle = .fullScreen
            DispatchQueue.main.async {
                self?.present(navigationController, animated: true)
            }
        }

        let storeButtonAction = UIAction { [weak self] _ in
            let storeFeedViewController = StoreFeedViewController(isMap: false)
            self?.navigationController?.pushViewController(storeFeedViewController, animated: true)
        }

        let commentButtonAction = UIAction { [weak self] _ in
            let feedCommentViewController = FeedCommentViewController()
            self?.navigationController?.pushViewController(feedCommentViewController, animated: true)
        }

        cell.userInfoView.userImageButton.addAction(userButtonAction, for: .touchUpInside)
        cell.userInfoView.userNameButton.addAction(userButtonAction, for: .touchUpInside)
        cell.storeInfoView.mapButton.addAction(mapButtonAction, for: .touchUpInside)
        cell.storeInfoView.storeNameButton.addAction(storeButtonAction, for: .touchUpInside)
        cell.commentButton.addAction(commentButtonAction, for: .touchUpInside)

        cell.userInfoView.userImageButton.setImage(ImageLiteral.food2, for: .normal)
        cell.commentLabel.text = """
        이번에 학교 앞에 새로 생겼길래 가봤는데 너무 맛있었어요.
        이번에 학교 앞에 새로 생겼길래 가봤는데 너무 맛있었어요.
        이번에 학교 앞에 새로 생겼길래 가봤는데 너무 맛있었어요.
        """

        return cell
    }
}

extension StoreFeedViewController {
    /* Standard scroll-view delegate */
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let contentSize = scrollView.contentSize.height

        if contentSize - scrollView.contentOffset.y <= scrollView.bounds.height {
            didScrollToBottom()
        }
    }

    private func didScrollToBottom() {}
}
