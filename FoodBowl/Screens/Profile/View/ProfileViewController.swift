//
//  ProfileViewController.swift
//  FoodBowl
//
//  Created by COBY_PRO on 2022/12/23.
//

import MapKit
import MessageUI
import UIKit

import SnapKit
import Then

final class ProfileViewController: MapViewController {
    var isOwn: Bool

    private var viewModel = ProfileViewModel()

    init(isOwn: Bool) {
        self.isOwn = isOwn
        super.init(nibName: nil, bundle: nil)
        self.modalView = FriendFeedView()
    }

    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private lazy var plusButton = PlusButton().then {
        let action = UIAction { [weak self] _ in
            let addFeedViewController = NewFeedViewController()
            let navigationController = UINavigationController(rootViewController: addFeedViewController)
            navigationController.modalPresentationStyle = .fullScreen
            DispatchQueue.main.async {
                self?.present(navigationController, animated: true)
            }
        }
        $0.addAction(action, for: .touchUpInside)
    }

    private lazy var settingButton = SettingButton().then {
        let settingAction = UIAction { [weak self] _ in
            let settingViewController = SettingViewController()
            self?.navigationController?.pushViewController(settingViewController, animated: true)
        }
        $0.addAction(settingAction, for: .touchUpInside)
    }

    private lazy var optionButton = OptionButton().then {
        let optionButtonAction = UIAction { [weak self] _ in
            let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)

            let report = UIAlertAction(title: "신고하기", style: .destructive, handler: { _ in
                self?.sendReportMail()
            })
            let cancel = UIAlertAction(title: "취소", style: .cancel, handler: nil)

            alert.addAction(cancel)
            alert.addAction(report)

            self?.present(alert, animated: true, completion: nil)
        }
        $0.addAction(optionButtonAction, for: .touchUpInside)
    }

    let userNicknameLabel = UILabel().then {
        $0.font = UIFont.preferredFont(forTextStyle: .title2, weight: .bold)
        $0.text = "coby5502"
        $0.textColor = .mainText
    }

    private lazy var profileHeaderView = ProfileHeaderView().then {
        let followerAction = UIAction { [weak self] _ in
            let followerViewController = FollowerViewController()
            self?.navigationController?.pushViewController(followerViewController, animated: true)
        }
        let followingAction = UIAction { [weak self] _ in
            let followingViewController = FollowingViewController()
            self?.navigationController?.pushViewController(followingViewController, animated: true)
        }
        let followButtonAction = UIAction { [weak self] _ in
            self?.followUser()
        }
        let editButtonAction = UIAction { [weak self] _ in
            let editProfileViewController = ProfileEditViewController()
            let navigationController = UINavigationController(rootViewController: editProfileViewController)
            navigationController.modalPresentationStyle = .fullScreen
            DispatchQueue.main.async {
                self?.present(navigationController, animated: true)
            }
        }
        $0.followerInfoButton.addAction(followerAction, for: .touchUpInside)
        $0.followingInfoButton.addAction(followingAction, for: .touchUpInside)
        $0.followButton.addAction(followButtonAction, for: .touchUpInside)
        $0.editButton.addAction(editButtonAction, for: .touchUpInside)
    }

    override func viewDidLoad() {
        setupBackButton()
        super.viewDidLoad()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.isNavigationBarHidden = false
        Task {
            await viewModel.getMyProfile()
            setupData()
        }
    }

    private func setupData() {
        profileHeaderView.userInfoLabel.text = viewModel.myProfile?.introduction
        profileHeaderView.followerInfoButton.numberLabel.text = "\(viewModel.myProfile!.followerCount)"
        profileHeaderView.followingInfoButton.numberLabel.text = "\(viewModel.myProfile!.followingCount)"
        if isOwn {
            userNicknameLabel.text = viewModel.myProfile?.nickname
        } else {
            title = viewModel.myProfile?.nickname
        }
    }

    override func setupLayout() {
        super.setupLayout()
        mapHeaderView.removeFromSuperview()
        view.addSubviews(profileHeaderView)

        profileHeaderView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(100)
        }

        trakingButton.snp.makeConstraints {
            $0.trailing.equalToSuperview().inset(BaseSize.horizantalPadding)
            $0.top.equalTo(profileHeaderView.snp.bottom).offset(20)
            $0.height.width.equalTo(40)
        }
    }

    override func configureUI() {
        super.configureUI()
        guard let navigationBarHeigth = navigationController?.navigationBar.frame.height else { return }
        let navBarHeight = Size.topPadding + navigationBarHeigth
        modalMaxHeight = UIScreen.main.bounds.height - navBarHeight - 180

        grabbarView.modalTitleLabel.text = "나의 맛집"
        grabbarView.modalResultLabel.text = "4개의 맛집, 10개의 후기"
    }

    override func setupNavigationBar() {
        super.setupNavigationBar()
        navigationController?.isNavigationBarHidden = true

        if isOwn {
            let userNicknameLabel = makeBarButtonItem(with: userNicknameLabel)
            let plusButton = makeBarButtonItem(with: plusButton)
            let settingButton = makeBarButtonItem(with: settingButton)
            navigationItem.leftBarButtonItem = userNicknameLabel
            navigationItem.rightBarButtonItems = [settingButton, plusButton]
            profileHeaderView.followButton.isHidden = true
        } else {
            let optionButton = makeBarButtonItem(with: optionButton)
            navigationItem.rightBarButtonItem = optionButton
            profileHeaderView.editButton.isHidden = true
        }
    }

    private func followUser() {
        profileHeaderView.followButton.isSelected.toggle()
    }
}
