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

    private let settingButton = SettingButton()

    // MARK: - life cycle

    override func render() {}

    override func setupNavigationBar() {
        super.setupNavigationBar()

        let settingButton = makeBarButtonItem(with: settingButton)
        navigationItem.leftBarButtonItem = nil
        navigationItem.rightBarButtonItem = settingButton
        title = "coby5502"
    }
}
