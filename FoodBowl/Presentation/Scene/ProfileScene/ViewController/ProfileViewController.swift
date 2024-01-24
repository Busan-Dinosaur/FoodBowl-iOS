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
    
    // MARK: - ui component
    
    let userNicknameLabel = PaddingLabel().then {
        $0.font = .font(.regular, ofSize: 22)
        $0.text = "그냥저냥"
        $0.textColor = .mainTextColor
        $0.padding = UIEdgeInsets(top: 0, left: 4, bottom: 0, right: 0)
        $0.frame = CGRect(x: 0, y: 0, width: 200, height: 0)
    }
    lazy var optionButton = OptionButton().then {
        let optionButtonAction = UIAction { [weak self] _ in
            guard let self = self else { return }
            guard let viewModel = self.viewModel as? ProfileViewModel else { return }
            self.presentMemberOptionAlert(memberId: viewModel.memberId)
        }
        $0.addAction(optionButtonAction, for: .touchUpInside)
    }
    private lazy var profileHeaderView = ProfileHeaderView().then {
        let followerAction = UIAction { [weak self] _ in
            guard let self = self else { return }
            guard let profileViewModel = self.viewModel as? ProfileViewModel else { return }
            let repository = FollowRepositoryImpl()
            let usecase = FollowUsecaseImpl(repository: repository)
            let viewModel = FollowerViewModel(
                usecase: usecase,
                memberId: profileViewModel.memberId,
                isOwn: self.isOwn
            )
            let viewController = FollowerViewController(viewModel: viewModel)
            
            self.navigationController?.pushViewController(viewController, animated: true)
        }
        let followingAction = UIAction { [weak self] _ in 
            guard let self = self else { return }
            guard let profileViewModel = self.viewModel as? ProfileViewModel else { return }
            let repository = FollowRepositoryImpl()
            let usecase = FollowUsecaseImpl(repository: repository)
            let viewModel = FollowingViewModel(usecase: usecase, memberId: profileViewModel.memberId)
            let viewController = FollowingViewController(viewModel: viewModel)
            
            self.navigationController?.pushViewController(viewController, animated: true)
        }
        let followButtonAction = UIAction { [weak self] _ in
            guard let self = self else { return }
            guard let viewModel = self.viewModel as? ProfileViewModel else { return }
            self.followButtonDidTapPublisher.send((viewModel.memberId, true)) // 수정해야함
        }
        let editButtonAction = UIAction { [weak self] _ in
            guard let self = self else { return }
            let repository = UpdateProfileRepositoryImpl()
            let usecase = UpdateProfileUsecaseImpl(repository: repository)
            let viewModel = UpdateProfileViewModel(usecase: usecase)
            let viewController = UpdateProfileViewController(viewModel: viewModel)
            
            self.navigationController?.pushViewController(viewController, animated: true)
        }
        $0.followerInfoButton.addAction(followerAction, for: .touchUpInside)
        $0.followingInfoButton.addAction(followingAction, for: .touchUpInside)
        $0.followButton.addAction(followButtonAction, for: .touchUpInside)
        $0.editButton.addAction(editButtonAction, for: .touchUpInside)
    }
    
    override func setupNavigationBar() {
        guard let viewModel = self.viewModel as? ProfileViewModel else { return }
        
        if isOwn {
            let userNicknameLabel = makeBarButtonItem(with: userNicknameLabel)
            let plusButton = makeBarButtonItem(with: plusButton)
            let settingButton = makeBarButtonItem(with: settingButton)
            navigationItem.leftBarButtonItem = userNicknameLabel
            navigationItem.rightBarButtonItems = [settingButton, plusButton]
            profileHeaderView.followButton.isHidden = true
        } else {
            if UserDefaultStorage.id == viewModel.memberId {
                profileHeaderView.followButton.isHidden = true
            } else {
                let optionButton = makeBarButtonItem(with: optionButton)
                navigationItem.rightBarButtonItem = optionButton
            }
            profileHeaderView.editButton.isHidden = true
        }
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

        trackingButton.snp.makeConstraints {
            $0.trailing.equalToSuperview().inset(10)
            $0.top.equalTo(categoryListView.snp.bottom).offset(20)
            $0.height.width.equalTo(40)
        }
    }

    override func configureUI() {
        super.configureUI()
        self.modalMaxHeight = UIScreen.main.bounds.height - SizeLiteral.topAreaPadding - navBarHeight - 180
    }
}
