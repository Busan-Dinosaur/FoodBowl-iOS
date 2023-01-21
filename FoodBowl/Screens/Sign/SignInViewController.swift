//
//  SignInViewController.swift
//  FoodBowl
//
//  Created by COBY_PRO on 2023/01/22.
//

import UIKit

import SnapKit
import Then

final class SignInViewController: BaseViewController {
    var delegate: SetCategoryViewControllerDelegate?
    private let categories = Category.allCases

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

    private lazy var signInButton = MainButton().then {
        $0.label.text = "로그인"

        let action = UIAction { [weak self] _ in
            let tabbarViewController = UINavigationController(rootViewController: TabbarViewController())
            tabbarViewController.modalPresentationStyle = .fullScreen
            tabbarViewController.modalTransitionStyle = .crossDissolve
            DispatchQueue.main.async {
                self?.present(tabbarViewController, animated: true)
            }
        }
        $0.addAction(action, for: .touchUpInside)
    }

    private let findIDLabel = UILabel().then {
        $0.text = "아이디 찾기"
        $0.textColor = .grey001
        $0.font = UIFont.preferredFont(forTextStyle: .callout, weight: .regular)
    }

    private let findPasswordLabel = UILabel().then {
        $0.text = "비밀번호 찾기"
        $0.textColor = .grey001
        $0.font = UIFont.preferredFont(forTextStyle: .callout, weight: .regular)
    }

    private let stackView = UIStackView().then {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.axis = .horizontal
        $0.alignment = .center
        $0.distribution = .equalSpacing
    }

    // MARK: - life cycle

    override func render() {
        view.addSubviews(emailLabel, emailField, passwordLabel, passwordField, stackView, signInButton)

        [findIDLabel, findPasswordLabel].forEach {
            stackView.addArrangedSubview($0)
        }

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

        stackView.snp.makeConstraints {
            $0.top.equalTo(passwordField.snp.bottom).offset(40)
            $0.centerX.equalToSuperview()
            $0.width.equalTo(200)
        }

        signInButton.snp.makeConstraints {
            $0.leading.trailing.bottom.equalToSuperview().inset(20)
            $0.bottom.equalTo(view.safeAreaLayoutGuide).inset(20)
            $0.height.equalTo(60)
        }
    }

    override func setupNavigationBar() {
        super.setupNavigationBar()
        title = "이메일로 로그인"
    }
}
