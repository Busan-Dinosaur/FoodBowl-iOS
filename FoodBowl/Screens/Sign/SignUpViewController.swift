//
//  SignUpViewController.swift
//  FoodBowl
//
//  Created by COBY_PRO on 2023/01/22.
//

import UIKit

import SnapKit
import Then

final class SignUpViewController: BaseViewController {
    // MARK: - property

    private let emailLabel = UILabel().then {
        $0.text = "아이디"
        $0.font = UIFont.preferredFont(forTextStyle: .body, weight: .medium)
    }

    private let emailField = UITextField().then {
        let attributes = [
            NSAttributedString.Key.foregroundColor: UIColor.grey001,
            NSAttributedString.Key.font: UIFont.preferredFont(forTextStyle: .body, weight: .regular)
        ]

        $0.backgroundColor = .white
        $0.attributedPlaceholder = NSAttributedString(string: "이메일 주소", attributes: attributes)
        $0.autocapitalizationType = .none
        $0.layer.cornerRadius = 12
        $0.layer.masksToBounds = true
        $0.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 0))
        $0.leftViewMode = .always
        $0.clipsToBounds = false
        $0.clearButtonMode = .always
        $0.makeBorderLayer(color: .grey002)
    }

    private let passwordLabel = UILabel().then {
        $0.text = "비밀번호"
        $0.font = UIFont.preferredFont(forTextStyle: .body, weight: .medium)
    }

    private let passwordField = UITextField().then {
        let attributes = [
            NSAttributedString.Key.foregroundColor: UIColor.grey001,
            NSAttributedString.Key.font: UIFont.preferredFont(forTextStyle: .body, weight: .regular)
        ]

        $0.backgroundColor = .white
        $0.attributedPlaceholder = NSAttributedString(string: "영문, 숫자, 특수문자 조합 8자리 이상", attributes: attributes)
        $0.autocapitalizationType = .none
        $0.layer.cornerRadius = 12
        $0.layer.masksToBounds = true
        $0.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 0))
        $0.leftViewMode = .always
        $0.clipsToBounds = false
        $0.isSecureTextEntry = true
        $0.clearButtonMode = .always
        $0.makeBorderLayer(color: .grey002)
    }

    private let passwordReLabel = UILabel().then {
        $0.text = "비밀번호 확인"
        $0.font = UIFont.preferredFont(forTextStyle: .body, weight: .medium)
    }

    private let passwordReField = UITextField().then {
        let attributes = [
            NSAttributedString.Key.foregroundColor: UIColor.grey001,
            NSAttributedString.Key.font: UIFont.preferredFont(forTextStyle: .body, weight: .regular)
        ]

        $0.backgroundColor = .white
        $0.attributedPlaceholder = NSAttributedString(string: "비밀번호 재입력", attributes: attributes)
        $0.autocapitalizationType = .none
        $0.layer.cornerRadius = 12
        $0.layer.masksToBounds = true
        $0.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 0))
        $0.leftViewMode = .always
        $0.clipsToBounds = false
        $0.isSecureTextEntry = true
        $0.clearButtonMode = .always
        $0.makeBorderLayer(color: .grey002)
    }

    private lazy var nextButton = MainButton().then {
        $0.label.text = "다음"

        let action = UIAction { [weak self] _ in
            let setProfileViewController = SetProfileViewController()
            self?.navigationController?.pushViewController(setProfileViewController, animated: true)
        }
        $0.addAction(action, for: .touchUpInside)
    }

    // MARK: - life cycle

    override func render() {
        view.addSubviews(emailLabel, emailField, passwordLabel, passwordField, passwordReLabel, passwordReField, nextButton)

        emailLabel.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top).inset(20)
            $0.leading.equalToSuperview().inset(20)
        }

        emailField.snp.makeConstraints {
            $0.top.equalTo(emailLabel.snp.bottom).offset(10)
            $0.leading.trailing.equalToSuperview().inset(20)
            $0.height.equalTo(60)
        }

        passwordLabel.snp.makeConstraints {
            $0.top.equalTo(emailField.snp.bottom).offset(30)
            $0.leading.equalToSuperview().inset(20)
        }

        passwordField.snp.makeConstraints {
            $0.top.equalTo(passwordLabel.snp.bottom).offset(10)
            $0.leading.trailing.equalToSuperview().inset(20)
            $0.height.equalTo(60)
        }

        passwordReLabel.snp.makeConstraints {
            $0.top.equalTo(passwordField.snp.bottom).offset(30)
            $0.leading.equalToSuperview().inset(20)
        }

        passwordReField.snp.makeConstraints {
            $0.top.equalTo(passwordReLabel.snp.bottom).offset(10)
            $0.leading.trailing.equalToSuperview().inset(20)
            $0.height.equalTo(60)
        }

        nextButton.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(20)
            $0.bottom.equalTo(view.safeAreaLayoutGuide).inset(20)
            $0.height.equalTo(60)
        }
    }

    override func setupNavigationBar() {
        super.setupNavigationBar()
        title = "회원가입"
    }
}
