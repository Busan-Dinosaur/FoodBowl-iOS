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
        $0.font = .font(.regular, ofSize: 22)
        $0.text = "그냥저냥"
        $0.textColor = .mainTextColor
        $0.padding = UIEdgeInsets(top: 0, left: 4, bottom: 0, right: 0)
        $0.frame = CGRect(x: 0, y: 0, width: 200, height: 0)
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
            let updateProfileViewController = UpdateProfileViewController()
            self?.navigationController?.pushViewController(updateProfileViewController, animated: true)
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
                guard let user = UserDefaultsManager.currentUser else { return }
                setupProfile(user: user)
                await viewModel.getProfile(id: user.id)
            } else {
                await viewModel.getProfile(id: 1)
            }
            setupData()
        }
    }

    private func setupProfile(user: MemberProfileResponse) {
        profileHeaderView.userInfoLabel.text = user.introduction
        profileHeaderView.followerInfoButton.numberLabel.text = "\(user.followerCount)"
        profileHeaderView.followingInfoButton.numberLabel.text = "\(user.followingCount)"

        if isOwn {
            userNicknameLabel.text = user.nickname
        } else {
            title = user.nickname
        }
    }

    private func setupData() {
        guard let user = viewModel.userProfile else { return }
        setupProfile(user: user)
    }

    override func setupLayout() {
        super.setupLayout()
        categoryListView.removeFromSuperview()
        view.addSubviews(profileHeaderView, categoryListView)

        profileHeaderView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(60)
        }

        categoryListView.snp.makeConstraints {
            $0.top.equalTo(profileHeaderView.snp.bottom)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(40)
        }

        trakingButton.snp.makeConstraints {
            $0.trailing.equalToSuperview().inset(10)
            $0.top.equalTo(categoryListView.snp.bottom).offset(20)
            $0.height.width.equalTo(40)
        }
    }

    override func configureUI() {
        super.configureUI()
        modalMaxHeight = UIScreen.main.bounds.height - topPadding - navBarHeight - 180
        grabbarView.modalResultLabel.text = "4개의 맛집"
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
