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
            guard let memberId = self?.memberId else { return }
            self?.presentMemberOptionAlert(memberId: memberId)
        }
        $0.addAction(optionButtonAction, for: .touchUpInside)
    }
    private lazy var profileHeaderView = ProfileHeaderView().then {
        let followerAction = UIAction { [weak self] _ in
            let repository = FollowRepositoryImpl()
            let usecase = FollowUsecaseImpl(repository: repository)
            let viewModel = FollowerViewModel(usecase: usecase, memberId: self?.memberId ?? 0)
            let viewController = FollowerViewController(viewModel: viewModel)
            
            self?.navigationController?.pushViewController(viewController, animated: true)
        }
        let followingAction = UIAction { [weak self] _ in
            let viewModel = FollowingViewModel(memberId: self?.memberId ?? 0)
            let viewController = FollowingViewController(viewModel: viewModel)
            self?.navigationController?.pushViewController(viewController, animated: true)
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
    
    // MARK: - property
    
    private let isOwn: Bool
    private let memberId: Int

    init(isOwn: Bool = false, memberId: Int = UserDefaultStorage.id) {
        self.isOwn = isOwn
        self.memberId = memberId
        super.init()
    }

    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupNavigationBar()
        self.setupLayout()
        self.configureUI()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.setUpProfile()
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
            if UserDefaultStorage.id == memberId {
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

        trakingButton.snp.makeConstraints {
            $0.trailing.equalToSuperview().inset(10)
            $0.top.equalTo(categoryListView.snp.bottom).offset(20)
            $0.height.width.equalTo(40)
        }
    }

    override func configureUI() {
        super.configureUI()
        modalMaxHeight = UIScreen.main.bounds.height - SizeLiteral.topAreaPadding - navBarHeight - 180
        viewModel.type = .member
        viewModel.memberId = self.memberId
    }

    private func setUpProfile() {
        Task {
            if isOwn {
                self.userNicknameLabel.text = UserDefaultStorage.nickname
                
                if let url = UserDefaultStorage.profileImageUrl {
                    self.profileHeaderView.userImageView.kf.setImage(with: URL(string: url))
                } else {
                    self.profileHeaderView.userImageView.image = ImageLiteral.defaultProfile
                }
                
                if let introduction = UserDefaultStorage.introduction {
                    self.profileHeaderView.userInfoLabel.text = introduction
                } else {
                    self.profileHeaderView.userInfoLabel.text = "소개를 작성해주세요"
                }
            }
            
            guard let member = await viewModel.getMemberProfile(id: memberId) else { return }
            
            DispatchQueue.main.async {
                self.userNicknameLabel.text = member.nickname
                self.profileHeaderView.followerInfoButton.numberLabel.text = "\(member.followerCount)명"
                self.profileHeaderView.followingInfoButton.numberLabel.text = "\(member.followingCount)명"
                self.profileHeaderView.followButton.isSelected = member.isFollowing
                
                if let url = member.profileImageUrl {
                    self.profileHeaderView.userImageView.kf.setImage(with: URL(string: url))
                } else {
                    self.profileHeaderView.userImageView.image = ImageLiteral.defaultProfile
                }
                
                if let introduction = member.introduction {
                    self.profileHeaderView.userInfoLabel.text = introduction
                } else {
                    self.profileHeaderView.userInfoLabel.text = "소개를 작성해주세요"
                }
                
                if !self.isOwn {
                    self.title = member.nickname
                }
                
                if self.memberId == UserDefaultStorage.id {
                    self.profileHeaderView.followButton.isHidden = true
                }
            }
        }
    }
    
    private func followButtonTapped() {
        Task {
            if profileHeaderView.followButton.isSelected {
                profileHeaderView.followButton.isSelected = await self.viewModel.unfollowMember(memberId: memberId)
            } else {
                profileHeaderView.followButton.isSelected = await self.viewModel.followMember(memberId: memberId)
            }
        }
    }
}
