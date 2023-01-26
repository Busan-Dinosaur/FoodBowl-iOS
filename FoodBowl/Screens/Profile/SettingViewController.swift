//
//  SettingViewController.swift
//  FoodBowl
//
//  Created by COBY_PRO on 2023/01/26.
//

import UIKit

import SnapKit
import Then

final class SettingViewController: BaseViewController {
    // MARK: - property

    private let appLogoView = UILabel().then {
        $0.font = UIFont.preferredFont(forTextStyle: .largeTitle, weight: .bold)
        $0.text = "FoodBowl"
    }

    private let guideLabel = UILabel().then {
        $0.text = "친구들과 함께 만들어가는 맛집지도"
        $0.font = UIFont.preferredFont(forTextStyle: .title3, weight: .medium)
    }

    // MARK: - life cycle

    override func render() {
        view.addSubviews(appLogoView, guideLabel)

        appLogoView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top).inset(100)
            $0.centerX.equalToSuperview()
        }

        guideLabel.snp.makeConstraints {
            $0.top.equalTo(appLogoView.snp.bottom).offset(40)
            $0.centerX.equalToSuperview()
        }
    }

    override func setupNavigationBar() {
        super.setupNavigationBar()
        title = "설정"
    }
}
