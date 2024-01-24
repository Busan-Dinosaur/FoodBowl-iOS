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
    
    private let userNicknameLabel = PaddingLabel().then {
        $0.font = .font(.regular, ofSize: 22)
        $0.text = "그냥저냥"
        $0.textColor = .mainTextColor
        $0.padding = UIEdgeInsets(top: 0, left: 4, bottom: 0, right: 0)
        $0.frame = CGRect(x: 0, y: 0, width: 200, height: 0)
    }
    private let optionButton = OptionButton()
    private let settingButton = SettingButton()
    private let profileHeaderView = ProfileHeaderView()

    override func setupLayout() {
        super.setupLayout()
        self.categoryListView.removeFromSuperview()
        self.view.addSubviews(
            self.profileHeaderView,
            self.categoryListView
        )

        self.profileHeaderView.snp.makeConstraints {
            $0.top.equalTo(self.view.safeAreaLayoutGuide)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(60)
        }

        self.categoryListView.snp.makeConstraints {
            $0.top.equalTo(self.profileHeaderView.snp.bottom)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(40)
        }

        self.trackingButton.snp.makeConstraints {
            $0.trailing.equalToSuperview().inset(10)
            $0.top.equalTo(self.categoryListView.snp.bottom).offset(20)
            $0.height.width.equalTo(40)
        }
    }

    override func configureUI() {
        super.configureUI()
        self.modalMaxHeight = UIScreen.main.bounds.height - SizeLiteral.topAreaPadding - navBarHeight - 180
    }
    
    // MARK: - func
    
    func configureNavigation() {
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
    
    override func setupAction() {
        super.setupAction()
        
        let optionButtonAction = UIAction { [weak self] _ in
            guard let self = self else { return }
            guard let viewModel = self.viewModel as? ProfileViewModel else { return }
            self.presentMemberOptionAlert(memberId: viewModel.memberId)
        }
        self.optionButton.addAction(optionButtonAction, for: .touchUpInside)
        
        let settingButtonAction = UIAction { [weak self] _ in
            self?.navigationController?.pushViewController(SettingViewController(), animated: true)
        }
        self.settingButton.addAction(settingButtonAction, for: .touchUpInside)
        
        let followerAction = UIAction { [weak self] _ in
            guard let self = self else { return }
            guard let viewModel = self.viewModel as? ProfileViewModel else { return }
            self.presentFollowerViewController(id: viewModel.memberId, isOwn: self.isOwn)
        }
        let followingAction = UIAction { [weak self] _ in
            guard let self = self else { return }
            guard let viewModel = self.viewModel as? ProfileViewModel else { return }
            self.presentFollowingViewController(id: viewModel.memberId)
        }
        let followButtonAction = UIAction { [weak self] _ in
            guard let self = self else { return }
            guard let viewModel = self.viewModel as? ProfileViewModel else { return }
            self.followButtonDidTapPublisher.send((viewModel.memberId, true)) // 수정해야함
        }
        let editButtonAction = UIAction { [weak self] _ in
            guard let self = self else { return }
            self.presentUpdateProfileViewController()
        }
        self.profileHeaderView.followerInfoButton.addAction(followerAction, for: .touchUpInside)
        self.profileHeaderView.followingInfoButton.addAction(followingAction, for: .touchUpInside)
        self.profileHeaderView.followButton.addAction(followButtonAction, for: .touchUpInside)
        self.profileHeaderView.editButton.addAction(editButtonAction, for: .touchUpInside)
    }
}
