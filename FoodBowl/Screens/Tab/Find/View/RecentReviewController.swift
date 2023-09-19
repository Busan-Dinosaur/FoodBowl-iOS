//
//  RecentReviewController.swift
//  FoodBowl
//
//  Created by COBY_PRO on 2023/09/20.
//

import MessageUI
import UIKit

import SnapKit
import Then

final class RecentReviewController: BaseViewController {
    private enum Size {
        static let collectionInset = UIEdgeInsets(
            top: 0,
            left: 0,
            bottom: 20,
            right: 0
        )
    }

    // MARK: - property
    private var refreshControl = UIRefreshControl()

    private var storeHeaderView = StoreHeaderView()

    private let collectionViewFlowLayout = DynamicHeightCollectionViewFlowLayout().then {
        $0.sectionInset = Size.collectionInset
        $0.minimumLineSpacing = 20
        $0.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
    }

    private lazy var listCollectionView = UICollectionView(frame: .zero, collectionViewLayout: collectionViewFlowLayout).then {
        $0.dataSource = self
        $0.delegate = self
        $0.showsVerticalScrollIndicator = false
        $0.register(FeedNSCollectionViewCell.self, forCellWithReuseIdentifier: FeedNSCollectionViewCell.className)
        $0.backgroundColor = .mainBackgroundColor
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupRefreshControl()
    }

    override func setupLayout() {
        view.addSubviews(listCollectionView)

        listCollectionView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }

    override func setupNavigationBar() {
        super.setupNavigationBar()
        title = "최근 후기"
    }

    private func setupRefreshControl() {
        let action = UIAction { [weak self] _ in
            self?.loadData()
        }
        refreshControl.addAction(action, for: .valueChanged)
        refreshControl.tintColor = .grey002
        listCollectionView.refreshControl = refreshControl
    }

    private func loadData() {}
}

extension RecentReviewController {
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
extension RecentReviewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_: UICollectionView, numberOfItemsInSection _: Int) -> Int {
        return 10
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: FeedNSCollectionViewCell.className,
            for: indexPath
        ) as? FeedNSCollectionViewCell else {
            return UICollectionViewCell()
        }

        cell.userButtonTapAction = { [weak self] _ in
            let profileViewController = ProfileViewController(isOwn: false)
            self?.navigationController?.pushViewController(profileViewController, animated: true)
        }

        cell.optionButtonTapAction = { [weak self] _ in
            let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)

            let edit = UIAlertAction(title: "수정", style: .default, handler: { _ in
                let viewModel = UpdateReviewViewModel()
                let updateReviewViewController = UpdateReviewViewController(viewModel: viewModel)
                let navigationController = UINavigationController(rootViewController: updateReviewViewController)
                DispatchQueue.main.async {
                    self?.present(navigationController, animated: true)
                }
            })
            let report = UIAlertAction(title: "신고", style: .destructive, handler: { _ in
                self?.sendReportMail()
            })
            let cancel = UIAlertAction(title: "취소", style: .cancel, handler: nil)

            alert.addAction(edit)
            alert.addAction(cancel)
            alert.addAction(report)

            self?.present(alert, animated: true, completion: nil)
        }

        cell.followButtonTapAction = { _ in
            cell.userInfoView.followButton.isSelected.toggle()
        }

        return cell
    }
}
