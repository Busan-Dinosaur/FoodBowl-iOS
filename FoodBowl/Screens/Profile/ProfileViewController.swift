//
//  ProfileViewController.swift
//  FoodBowl
//
//  Created by COBY_PRO on 2022/12/23.
//

import UIKit

import SnapKit
import Then

final class ProfileViewController: BaseViewController {
    // MARK: - property

    private let userNicknameLabel = UILabel().then {
        $0.font = UIFont.preferredFont(forTextStyle: .title1, weight: .bold)
        $0.text = "coby5502"
    }

    private let settingButton = SettingButton()

    private let userProfileView = UserProfileView()

    // MARK: - life cycle

    override func render() {
        view.addSubviews(userProfileView)

        userProfileView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(100)
        }
    }

    override func setupNavigationBar() {
        super.setupNavigationBar()

        let userNicknameLabel = makeBarButtonItem(with: userNicknameLabel)
        let settingButton = makeBarButtonItem(with: settingButton)
        navigationItem.leftBarButtonItem = userNicknameLabel
        navigationItem.rightBarButtonItem = settingButton
    }
}
