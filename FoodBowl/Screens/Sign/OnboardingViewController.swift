//
//  OnboardingViewController.swift
//  FoodBowl
//
//  Created by COBY_PRO on 2023/01/22.
//

import UIKit

import SnapKit
import Then

final class OnboardingViewController: BaseViewController {
    var delegate: SetCategoryViewControllerDelegate?
    private let categories = Category.allCases

    // MARK: - property

    private let guideLabel = UILabel().then {
        $0.text = "로그인"
        $0.font = UIFont.preferredFont(forTextStyle: .title3, weight: .medium)
    }

    // MARK: - life cycle

    override func render() {
        view.addSubviews(guideLabel)

        guideLabel.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top).inset(20)
            $0.leading.equalToSuperview().inset(20)
        }
    }

    override func setupNavigationBar() {
        navigationController?.isNavigationBarHidden = true
    }
}
