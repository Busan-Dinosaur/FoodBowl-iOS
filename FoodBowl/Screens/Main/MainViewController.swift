//
//  MainViewController.swift
//  FoodBowl
//
//  Created by COBY_PRO on 2022/12/23.
//

import CoreLocation
import MessageUI
import UIKit

import SnapKit
import Then

final class MainViewController: BaseViewController {
    private enum Size {
        static let collectionInset = UIEdgeInsets(
            top: 0,
            left: 0,
            bottom: 20,
            right: 0
        )
    }

    private var locationAlert: UIAlertController {
        let alert = UIAlertController(title: "위치 정보를 사용할 수 없습니다", message: "", preferredStyle: .alert)
        let cancel = UIAlertAction(title: "취소", style: .default) { _ in
            self.navigationController?.popViewController(animated: true)
        }

        let action = UIAlertAction(title: "허용", style: .default) { _ in
            guard let settingsUrl = URL(string: UIApplication.openSettingsURLString) else { return }

            if UIApplication.shared.canOpenURL(settingsUrl) {
                UIApplication.shared.open(settingsUrl, completionHandler: nil)
            }
        }

        alert.addAction(cancel)
        alert.addAction(action)

        return alert
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
        $0.showsVerticalScrollIndicator = false
        $0.register(FeedCollectionViewCell.self, forCellWithReuseIdentifier: FeedCollectionViewCell.className)
        $0.backgroundColor = .clear
    }

    private let emptyFeedView = EmptyFeedView()

    private let appLogoView = UILabel().then {
        $0.font = .font(.regular, ofSize: 24)
        $0.textColor = .mainText
        $0.text = "FoodBowl"
    }

    private lazy var plusButton = PlusButton().then {
        let action = UIAction { [weak self] _ in
            let addFeedViewController = AddFeedViewController()
            let navigationController = UINavigationController(rootViewController: addFeedViewController)
            navigationController.modalPresentationStyle = .fullScreen
            DispatchQueue.main.async {
                self?.present(navigationController, animated: true)
            }
        }
        $0.addAction(action, for: .touchUpInside)
    }

    // MARK: - life cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setupRefreshControl()
        loadData()

        LocationManager.shared.checkLocationService()
        observerNotification()
    }

    override func setupLayout() {
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
        refreshControl.tintColor = .grey002
        listCollectionView.refreshControl = refreshControl
    }

    private func loadData() {}

    func observerNotification() {
        NotificationCenter.default.addObserver(forName: .sharedLocation, object: nil, queue: .main) { notification in
            guard let object = notification.object as? [String: Any] else { return }
            guard let error = object["error"] as? Bool else { return }

            if error {
                print("error to access location service.")
                self.present(self.locationAlert, animated: true, completion: nil)
            } else {
                guard let location = object["location"] as? CLLocation else { return }
                print(location.coordinate.latitude)
            }
        }
    }
}

// MARK: - UICollectionViewDataSource, UICollectionViewDelegate

extension MainViewController: UICollectionViewDataSource, UICollectionViewDelegate {
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

        cell.userButtonTapAction = { [weak self] _ in
            let profileViewController = ProfileViewController(isOwn: false)
            self?.navigationController?.pushViewController(profileViewController, animated: true)
        }

        cell.followButtonTapAction = { [weak self] _ in
            cell.userInfoView.followButton.isSelected = !cell.userInfoView.followButton.isSelected
        }

        cell.mapButtonTapAction = { [weak self] _ in
            let showWebViewController = ShowWebViewController()
            showWebViewController.title = "가게 정보"
            showWebViewController.url = ""
            let navigationController = UINavigationController(rootViewController: showWebViewController)
            navigationController.modalPresentationStyle = .fullScreen
            DispatchQueue.main.async {
                self?.present(navigationController, animated: true)
            }
        }

        cell.storeButtonTapAction = { [weak self] _ in
            let storeFeedViewController = StoreFeedViewController()
            storeFeedViewController.title = "틈새라면"
            self?.navigationController?.pushViewController(storeFeedViewController, animated: true)
        }

        cell.bookmarkButtonTapAction = { [weak self] _ in
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

        cell.commentButtonTapAction = { [weak self] _ in
            let feedCommentViewController = ChatViewController()
            self?.navigationController?.pushViewController(feedCommentViewController, animated: true)
        }

        cell.optionButtonTapAction = { [weak self] _ in
            let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)

            let report = UIAlertAction(title: "신고하기", style: .destructive, handler: { _ in
                self?.sendReportMail()
            })
            let cancel = UIAlertAction(title: "취소", style: .cancel, handler: nil)

            alert.addAction(cancel)
            alert.addAction(report)

            self?.present(alert, animated: true, completion: nil)
        }

        cell.commentLabelTapAction = { _ in
            cell.collapsed = !cell.collapsed
            self.collectionViewFlowLayout.invalidateLayout()
        }

        cell.userInfoView.userImageButton.setImage(ImageLiteral.food2, for: .normal)
        cell.commentLabel.text = """
            이번에 학교 앞에 새로 생겼길래 가봤는데 너무 맛있었어요.
            이번에 학교 앞에 새로 생겼길래 가봤는데 너무 맛있었어요.
            이번에 학교 앞에 새로 생겼길래 가봤는데 너무 맛있었어요.
            """

        return cell
    }
}

extension MainViewController {
    // Standard scroll-view delegate
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let contentSize = scrollView.contentSize.height

        if contentSize - scrollView.contentOffset.y <= scrollView.bounds.height {
            didScrollToBottom()
        }
    }

    private func didScrollToBottom() {}
}

extension MainViewController: MFMailComposeViewControllerDelegate {
    func sendReportMail() {
        if MFMailComposeViewController.canSendMail() {
            let composeVC = MFMailComposeViewController()
            let emailAdress = "foodbowl5502@gmail.com"
            let messageBody = """
                신고 사유를 작성해주세요.
                """

            composeVC.mailComposeDelegate = self
            composeVC.setToRecipients([emailAdress])
            composeVC.setSubject("[신고] 닉네임")
            composeVC.setMessageBody(messageBody, isHTML: false)
            composeVC.modalPresentationStyle = .fullScreen

            present(composeVC, animated: true, completion: nil)
        } else {
            showSendMailErrorAlert()
        }
    }

    private func showSendMailErrorAlert() {
        let sendMailErrorAlert = UIAlertController(title: "메일 전송 실패", message: "이메일 설정을 확인하고 다시 시도해주세요.", preferredStyle: .alert)
        let confirmAction = UIAlertAction(title: "확인", style: .default)
        sendMailErrorAlert.addAction(confirmAction)
        present(sendMailErrorAlert, animated: true, completion: nil)
    }

    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith _: MFMailComposeResult, error _: Error?) {
        controller.dismiss(animated: true, completion: nil)
    }
}
