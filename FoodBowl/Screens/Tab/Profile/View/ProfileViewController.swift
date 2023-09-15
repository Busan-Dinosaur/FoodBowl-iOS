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
    private var isOwn: Bool

    private var viewModel = ProfileViewModel()

    init(isOwn: Bool) {
        self.isOwn = isOwn
        super.init(nibName: nil, bundle: nil)
        self.modalView = FeedListView()
    }

    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    let userNicknameLabel = PaddingLabel().then {
        $0.font = UIFont.preferredFont(forTextStyle: .title2, weight: .bold)
        $0.text = "coby5502"
        $0.textColor = .mainText
        $0.padding = UIEdgeInsets(top: 0, left: 4, bottom: 0, right: 0)
        $0.frame = CGRect(x: 0, y: 0, width: 150, height: 0)
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
            self?.navigationController?.pushViewController(editProfileViewController, animated: true)
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
            if isOwn {
                let id = UserDefaultStorage.userID
                await viewModel.getProfile(id: id)
            } else {
                await viewModel.getProfile(id: 1)
            }
            setupData()
        }
    }

    private func setupData() {
        guard let follower = viewModel.profileData?.followerCount,
              let following = viewModel.profileData?.followingCount else {
            return
        }

        profileHeaderView.userInfoLabel.text = viewModel.profileData?.introduction
        profileHeaderView.followerInfoButton.numberLabel.text = "\(follower)"
        profileHeaderView.followingInfoButton.numberLabel.text = "\(following)"

        if isOwn {
            userNicknameLabel.text = viewModel.profileData?.nickname
        } else {
            title = viewModel.profileData?.nickname
        }
    }

    override func setupLayout() {
        super.setupLayout()
        categoryListView.removeFromSuperview()
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
        modalMaxHeight = UIScreen.main.bounds.height - topPadding - navBarHeight - 180

        grabbarView.modalTitleLabel.text = "나의 맛집"
        grabbarView.modalResultLabel.text = "4개의 맛집, 10개의 후기"
    }

    override func setupNavigationBar() {
        super.setupNavigationBar()

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
