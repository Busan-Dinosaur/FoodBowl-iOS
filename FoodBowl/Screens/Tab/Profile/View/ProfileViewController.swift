//
//  ProfileViewController.swift
//  FoodBowl
//
//  Created by COBY_PRO on 2022/12/23.
//

import MapKit
import MessageUI
import UIKit

import Kingfisher
import SnapKit
import Then

final class ProfileViewController: MapViewController {
    private var isOwn: Bool
    private var memberId: Int
    private var member: MemberProfileResponse?

    private var viewModel = ProfileViewModel()

    init(isOwn: Bool = false, memberId: Int = UserDefaultsManager.currentUser?.id ?? 0) {
        self.isOwn = isOwn
        self.memberId = memberId
        super.init()
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

    lazy var optionButton = OptionButton().then {
        let optionButtonAction = UIAction { [weak self] _ in
            guard let memberId = self?.memberId else { return }
            self?.presentMemberOptionAlert(memberId: memberId)
        }
        $0.addAction(optionButtonAction, for: .touchUpInside)
    }

    private lazy var profileHeaderView = ProfileHeaderView().then {
        let followerAction = UIAction { [weak self] _ in
            let followerViewController = FollowerViewController(memberId: self?.memberId ?? 0)
            self?.navigationController?.pushViewController(followerViewController, animated: true)
        }
        let followingAction = UIAction { [weak self] _ in
            let followingViewController = FollowingViewController(memberId: self?.memberId ?? 0)
            self?.navigationController?.pushViewController(followingViewController, animated: true)
        }
        let followButtonAction = UIAction { [weak self] _ in
            self?.followButtonTapped()
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

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.isNavigationBarHidden = false
        setupMember()
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
        modalMaxHeight = UIScreen.main.bounds.height - SizeLiteral.topAreaPadding - navBarHeight - 180
    }

    private func setupNavigationBar() {
        if isOwn {
            let userNicknameLabel = makeBarButtonItem(with: userNicknameLabel)
            let plusButton = makeBarButtonItem(with: plusButton)
            let settingButton = makeBarButtonItem(with: settingButton)
            navigationItem.leftBarButtonItem = userNicknameLabel
            navigationItem.rightBarButtonItems = [settingButton, plusButton]
            profileHeaderView.followButton.isHidden = true
        } else {
            if UserDefaultsManager.currentUser?.id ?? 0 == memberId {
                profileHeaderView.followButton.isHidden = true
            } else {
                let optionButton = makeBarButtonItem(with: optionButton)
                navigationItem.rightBarButtonItem = optionButton
            }
            profileHeaderView.editButton.isHidden = true
        }
    }

    private func setupMember() {
        Task {
            if isOwn {
                setUpMyProfile()
                await setUpMemberProfile()
            }
            await setUpMemberProfile()
        }
    }

    private func setUpMyProfile() {
        member = UserDefaultsManager.currentUser

        DispatchQueue.main.async {
            guard let member = self.member else { return }
            self.userNicknameLabel.text = member.nickname
            self.profileHeaderView.userInfoLabel.text = member.introduction
            self.profileHeaderView.followerInfoButton.numberLabel.text = "\(member.followerCount)명"
            self.profileHeaderView.followingInfoButton.numberLabel.text = "\(member.followingCount)명"
            if let url = member.profileImageUrl {
                self.profileHeaderView.userImageView.kf.setImage(with: URL(string: url))
            } else {
                self.profileHeaderView.userImageView.image = ImageLiteral.defaultProfile
            }
        }
    }

    private func setUpMemberProfile() async {
        member = await viewModel.getMemberProfile(id: memberId)

        DispatchQueue.main.async {
            guard let member = self.member else { return }
            self.userNicknameLabel.text = member.nickname
            self.profileHeaderView.userInfoLabel.text = member.introduction
            self.profileHeaderView.followerInfoButton.numberLabel.text = "\(member.followerCount)명"
            self.profileHeaderView.followingInfoButton.numberLabel.text = "\(member.followingCount)명"
            self.profileHeaderView.followButton.isSelected = member.isFollowing
            if let url = member.profileImageUrl {
                self.profileHeaderView.userImageView.kf.setImage(with: URL(string: url))
            } else {
                self.profileHeaderView.userImageView.image = ImageLiteral.defaultProfile
            }

            if self.isOwn {
                UserDefaultsManager.currentUser = member
            } else {
                self.title = member.nickname
            }
        }
    }

    override func loadReviews() async -> [Review] {
        guard let location = customLocation else { return [] }
        return await viewModel.getReviews(location: location, memberId: memberId)
    }

    override func loadStores() async -> [Store] {
        guard let location = customLocation else { return [] }
        return await viewModel.getStores(location: location, memberId: memberId)
    }

    override func reloadReviews() async -> [Review] {
        if let location = customLocation, let lastReviewId = viewModel.lastReviewId,
           let currentpageSize = viewModel.currentpageSize, currentpageSize >= viewModel.pageSize {
            return await viewModel.getReviews(
                location: location,
                memberId: memberId,
                lastReviewId: lastReviewId
            )
        }
        return []
    }

    private func followButtonTapped() {
        Task {
            if profileHeaderView.followButton.isSelected {
                profileHeaderView.followButton.isSelected = await self.viewModel.unfollowMember(memberId: memberId)
            } else {
                profileHeaderView.followButton.isSelected = await self.viewModel.followMember(memberId: memberId)
            }

            await setUpMemberProfile()
        }
    }
}
