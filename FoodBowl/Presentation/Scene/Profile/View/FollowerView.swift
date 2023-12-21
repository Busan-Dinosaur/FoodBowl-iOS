//
//  FollowerView.swift
//  FoodBowl
//
//  Created by Coby on 12/21/23.
//

import Combine
import UIKit

import SnapKit
import Then

final class FollowerView: UIView, BaseViewType {
    
    // MARK: - ui component
    
    lazy var listTableView = UITableView().then {
        $0.register(UserInfoTableViewCell.self, forCellReuseIdentifier: UserInfoTableViewCell.className)
        $0.delegate = self
        $0.dataSource = self
        $0.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 20, right: 0)
        $0.backgroundColor = .mainBackgroundColor
    }
    
    // MARK: - property
    
    private var isOwn: Bool
    private var memberId: Int
    var members = [MemberByFollow]() {
        didSet {
            DispatchQueue.main.async {
                self.listTableView.reloadData()
            }
        }
    }
    
    // MARK: - init
    
    init(memberId: Int = UserDefaultsManager.currentUser?.id ?? 0) {
        self.memberId = memberId
        self.isOwn = UserDefaultsManager.currentUser?.id ?? 0 == memberId
        super.init(frame: .zero)
        self.baseInit()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - base func
    
    func setupLayout() {
        self.addSubviews(listTableView)

        self.listTableView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    func configureUI() {
        self.backgroundColor = .mainBackgroundColor
    }
}

extension FollowerView: UITableViewDataSource, UITableViewDelegate {
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
            }
        } else {
            if UserDefaultsManager.currentUser?.id ?? 0 == member.memberId {
                cell.followButton.isHidden = true
            } else {
                cell.followButton.isHidden = false
                cell.followButton.isSelected = member.isFollowing
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
}
