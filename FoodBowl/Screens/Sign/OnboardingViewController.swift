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

    private lazy var signInButton = MainButton().then {
        $0.label.text = "로그인"

        let action = UIAction { [weak self] _ in
            let signInViewController = SignInViewController()
            self?.navigationController?.pushViewController(signInViewController, animated: true)
        }
        $0.addAction(action, for: .touchUpInside)
    }

    private lazy var signUpButton = MainButton().then {
        $0.label.text = "회원가입"
        $0.backgroundColor = .black

        let action = UIAction { [weak self] _ in
            let signUpViewController = SignUpViewController()
            self?.navigationController?.pushViewController(signUpViewController, animated: true)
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
        view.addSubviews(signUpButton, signInButton)

        signUpButton.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(20)
            $0.bottom.equalTo(view.safeAreaLayoutGuide).inset(20)
            $0.height.equalTo(60)
        }

        signInButton.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(20)
            $0.bottom.equalTo(signUpButton.snp.top).offset(-10)
            $0.height.equalTo(60)
        }
    }
}
