//
//  OnboardingViewController.swift
//  FoodBowl
//
//  Created by COBY_PRO on 2023/01/23.
//

import UIKit

import SnapKit
import Then

final class OnboardingViewController: BaseViewController {
    // MARK: - property

    private let appLogoView = UILabel().then {
        $0.font = UIFont.preferredFont(forTextStyle: .largeTitle, weight: .bold)
        $0.text = "FoodBowl"
    }

    private let guideLabel = UILabel().then {
        $0.text = "친구들과 함께 만들어가는 맛집지도"
        $0.font = UIFont.preferredFont(forTextStyle: .title3, weight: .medium)
    }

    private lazy var signUpButton = MainButton().then {
        $0.label.text = "이메일로 가입"
        $0.backgroundColor = .black

        let action = UIAction { [weak self] _ in
            let signUpViewController = SignUpViewController()
            self?.navigationController?.pushViewController(signUpViewController, animated: true)
        }
        $0.addAction(action, for: .touchUpInside)
    }

    private lazy var signInButton = MainButton().then {
        $0.label.text = "이메일로 로그인"

        let action = UIAction { [weak self] _ in
            let signInViewController = SignInViewController()
            self?.navigationController?.pushViewController(signInViewController, animated: true)
        }
        $0.addAction(action, for: .touchUpInside)
    }

    // MARK: - life cycle

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.isNavigationBarHidden = true
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.isNavigationBarHidden = false
    }

    override func render() {
        view.addSubviews(appLogoView, guideLabel, signInButton, signUpButton)

        appLogoView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top).inset(100)
            $0.centerX.equalToSuperview()
        }

        guideLabel.snp.makeConstraints {
            $0.top.equalTo(appLogoView.snp.bottom).offset(40)
            $0.centerX.equalToSuperview()
        }

        signInButton.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(20)
            $0.bottom.equalTo(view.safeAreaLayoutGuide).inset(20)
            $0.height.equalTo(60)
        }

        signUpButton.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(20)
            $0.bottom.equalTo(signInButton.snp.top).offset(-10)
            $0.height.equalTo(60)
        }
    }
}
