//
//  StoreFeedViewController.swift
//  FoodBowl
//
//  Created by COBY_PRO on 2023/01/18.
//

import MessageUI
import UIKit

import SnapKit
import Then

final class StoreFeedViewController: BaseViewController {
    private enum Size {
        static let collectionInset = UIEdgeInsets(
            top: 0,
            left: 0,
            bottom: 20,
            right: 0
        )
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
        $0.backgroundColor = .clear
    }

    private let emptyFeedView = EmptyFeedView()

    // MARK: - life cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setupRefreshControl()
        loadData()
    }

    override func setupLayout() {
        view.addSubviews(listCollectionView)

        listCollectionView.snp.makeConstraints {
            $0.edges.equalToSuperview()
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
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: FeedCollectionViewCell.className,
            for: indexPath
        ) as? FeedCollectionViewCell else {
            return UICollectionViewCell()
        }

        cell.userButtonTapAction = { _ in
            let profileViewController = ProfileViewController(isOwn: false)
            self.navigationController?.pushViewController(profileViewController, animated: true)
        }

        cell.followButtonTapAction = { _ in
            cell.userInfoView.followButton.isSelected = !cell.userInfoView.followButton.isSelected
        }

        cell.mapButtonTapAction = { _ in
            let showWebViewController = ShowWebViewController()
            showWebViewController.title = "?????? ??????"
            showWebViewController.url = ""
            let navigationController = UINavigationController(rootViewController: showWebViewController)
            navigationController.modalPresentationStyle = .fullScreen
            DispatchQueue.main.async {
                self.present(navigationController, animated: true)
            }
        }

        cell.storeButtonTapAction = { _ in
            let storeFeedViewController = StoreFeedViewController()
            storeFeedViewController.title = "????????????"
            self.navigationController?.pushViewController(storeFeedViewController, animated: true)
        }

        cell.bookmarkButtonTapAction = { _ in
            if cell.bookmarkButton.isSelected {
                cell.bookmarkButton.setImage(
                    ImageLiteral.btnBookmark.resize(to: CGSize(width: 20, height: 20)).withRenderingMode(.alwaysTemplate),
                    for: .normal
                )
                cell.bookmarkButton.setTitle("  4", for: .normal)
            } else {
                cell.bookmarkButton.setImage(
                    ImageLiteral.btnBookmarkFill.resize(to: CGSize(width: 20, height: 20)).withRenderingMode(.alwaysTemplate),
                    for: .normal
                )
                cell.bookmarkButton.setTitle("  5", for: .normal)
            }
            cell.bookmarkButton.isSelected = !cell.bookmarkButton.isSelected
        }

        cell.commentButtonTapAction = { _ in
            let feedCommentViewController = ChatViewController()
            self.navigationController?.pushViewController(feedCommentViewController, animated: true)
        }

        cell.optionButtonTapAction = { _ in
            let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)

            let report = UIAlertAction(title: "????????????", style: .destructive, handler: { _ in
                self.sendReportMail()
            })
            let cancel = UIAlertAction(title: "??????", style: .cancel, handler: nil)

            alert.addAction(cancel)
            alert.addAction(report)

            self.present(alert, animated: true, completion: nil)
        }

        cell.commentLabelTapAction = { _ in
            cell.collapsed = !cell.collapsed
            self.collectionViewFlowLayout.invalidateLayout()
        }

        cell.userInfoView.userImageButton.setImage(ImageLiteral.food2, for: .normal)
        cell.commentLabel.text = """
            ????????? ?????? ?????? ?????? ???????????? ???????????? ?????? ???????????????.
            ????????? ?????? ?????? ?????? ???????????? ???????????? ?????? ???????????????.
            ????????? ?????? ?????? ?????? ???????????? ???????????? ?????? ???????????????.
            """

        return cell
    }
}

extension StoreFeedViewController {
    // Standard scroll-view delegate
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let contentSize = scrollView.contentSize.height

        if contentSize - scrollView.contentOffset.y <= scrollView.bounds.height {
            didScrollToBottom()
        }
    }

    private func didScrollToBottom() {}
}

extension StoreFeedViewController: MFMailComposeViewControllerDelegate {
    func sendReportMail() {
        if MFMailComposeViewController.canSendMail() {
            let composeVC = MFMailComposeViewController()
            let emailAdress = "foodbowl5502@gmail.com"
            let messageBody = """
                ?????? ????????? ??????????????????.
                """

            composeVC.mailComposeDelegate = self
            composeVC.setToRecipients([emailAdress])
            composeVC.setSubject("[??????] ?????????")
            composeVC.setMessageBody(messageBody, isHTML: false)
            composeVC.modalPresentationStyle = .fullScreen

            present(composeVC, animated: true, completion: nil)
        } else {
            showSendMailErrorAlert()
        }
    }

    private func showSendMailErrorAlert() {
        let sendMailErrorAlert = UIAlertController(title: "?????? ?????? ??????", message: "????????? ????????? ???????????? ?????? ??????????????????.", preferredStyle: .alert)
        let confirmAction = UIAlertAction(title: "??????", style: .default)
        sendMailErrorAlert.addAction(confirmAction)
        present(sendMailErrorAlert, animated: true, completion: nil)
    }

    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith _: MFMailComposeResult, error _: Error?) {
        controller.dismiss(animated: true, completion: nil)
    }
}
