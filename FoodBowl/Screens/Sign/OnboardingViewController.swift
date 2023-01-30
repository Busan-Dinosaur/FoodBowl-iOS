//
//  OnboardingViewController.swift
//  FoodBowl
//
//  Created by COBY_PRO on 2023/01/23.
//

import AuthenticationServices
import UIKit

import SnapKit
import Then

final class OnboardingViewController: BaseViewController {
    // MARK: - property

    private let appLogoView = UILabel().then {
        $0.font = UIFont.preferredFont(forTextStyle: .largeTitle, weight: .bold)
        $0.textColor = .mainText
        $0.text = "FoodBowl"
    }

    private let guideLabel = UILabel().then {
        $0.font = UIFont.preferredFont(forTextStyle: .title3, weight: .medium)
        $0.textColor = .mainText
        $0.text = "친구들과 함께 만들어가는 맛집지도"
    }

    private lazy var appleLoginButton = ASAuthorizationAppleIDButton(
        type: .signIn,
        style: traitCollection.userInterfaceStyle == .dark ? .white : .black
    ).then {
        let action = UIAction { [weak self] _ in
            let agreementViewController = AgreementViewController()
            self?.navigationController?.pushViewController(agreementViewController, animated: true)
        }
        $0.addAction(action, for: .touchUpInside)
        $0.cornerRadius = 30
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
        view.addSubviews(appLogoView, guideLabel, appleLoginButton)

        appLogoView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top).inset(100)
            $0.centerX.equalToSuperview()
        }

        guideLabel.snp.makeConstraints {
            $0.top.equalTo(appLogoView.snp.bottom).offset(40)
            $0.centerX.equalToSuperview()
        }

        appleLoginButton.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(20)
            $0.bottom.equalTo(view.safeAreaLayoutGuide).inset(20)
            $0.height.equalTo(60)
        }
    }
}
