//
//  FollowerViewController.swift
//  FoodBowl
//
//  Created by COBY_PRO on 2023/01/19.
//

import UIKit

import Kingfisher
import SnapKit
import Then

final class FollowerViewController: BaseViewController {
    private var isOwn: Bool
    private var memberId: Int

    var members = [MemberByFollow]() {
        didSet {
            DispatchQueue.main.async {
                self.userResultTableView.reloadData()
            }
        }
    }

    private var viewModel = MapViewModel()

    init(memberId: Int = UserDefaultsManager.currentUser?.id ?? 0) {
        self.isOwn = UserDefaultsManager.currentUser?.id ?? 0 == memberId
        self.memberId = memberId
        super.init()
    }

    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - property

    private lazy var userResultTableView = UITableView().then {
        $0.register(UserInfoTableViewCell.self, forCellReuseIdentifier: UserInfoTableViewCell.className)
        $0.delegate = self
        $0.dataSource = self
        $0.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 20, right: 0)
        $0.backgroundColor = .mainBackgroundColor
    }

    // MARK: - life cycle

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadData()
    }

    override func setupLayout() {
        view.addSubviews(userResultTableView)

        userResultTableView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }

    override func setupNavigationBar() {
        super.setupNavigationBar()
        title = "팔로워"
    }

    func loadData() {
        Task {
            await setupMembers()
        }
    }

    private func setupMembers() async {
        members = await viewModel.getFollowerMembers(memberId: memberId)
    }
}

extension FollowerViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_: UITableView, numberOfRowsInSection _: Int) -> Int {
        return members.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView
            .dequeueReusableCell(withIdentifier: UserInfoTableViewCell.className, for: indexPath) as? UserInfoTableViewCell
        else { return UITableViewCell() }

        let member = members[indexPath.item]

        cell.selectionStyle = .none
        cell.setupDataByMemberByFollow(member)

        if isOwn {
            if UserDefaultsManager.currentUser?.id ?? 0 == member.memberId {
                cell.followButton.isHidden = true
            } else {
                cell.followButton.isHidden = false
                cell.followButton.isSelected = true
                cell.followButtonTapAction = { [weak self] _ in
                    Task {
                        guard let self = self else { return }
                        if await self.viewModel.removeFollowingMember(memberId: member.memberId) {
//                            self.members = self.members.filter { $0.memberId != member.memberId }
                            DispatchQueue.main.async {
                                self.loadData()
                            }
                        }
                    }
                }
            }
        } else {
            if UserDefaultsManager.currentUser?.id ?? 0 == member.memberId {
                cell.followButton.isHidden = true
            } else {
                cell.followButton.isHidden = false
                cell.followButton.isSelected = member.isFollowing
                cell.followButtonTapAction = { [weak self] _ in
                    Task {
                        guard let self = self else { return }
                        if cell.followButton.isSelected {
                            if await self.viewModel.unfollowMember(memberId: member.memberId) {
                                self.members = self.members.map {
                                    var selectedMember = $0
                                    if selectedMember.memberId == member.memberId {
                                        selectedMember.isFollowing = false
                                    }
                                    return selectedMember
                                }
                            }
                        } else {
                            if await self.viewModel.followMember(memberId: member.memberId) {
                                self.members = self.members.map {
                                    var selectedMember = $0
                                    if selectedMember.memberId == member.memberId {
                                        selectedMember.isFollowing = true
                                    }
                                    return selectedMember
                                }
                            }
                        }
                    }
                }
            }
        }

        if let url = member.profileImageUrl {
            cell.userImageView.kf.setImage(with: URL(string: url))
        } else {
            cell.userImageView.image = ImageLiteral.defaultProfile
        }

        return cell
    }

    func tableView(_: UITableView, heightForRowAt _: IndexPath) -> CGFloat {
        return 64
    }

    func tableView(_: UITableView, didSelectRowAt indexPath: IndexPath) {
        let profileViewController = ProfileViewController(memberId: members[indexPath.item].memberId)

        DispatchQueue.main.async { [weak self] in
            self?.navigationController?.pushViewController(profileViewController, animated: true)
        }
    }
}
