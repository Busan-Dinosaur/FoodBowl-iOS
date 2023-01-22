//
//  SetProfileViewController.swift
//  FoodBowl
//
//  Created by COBY_PRO on 2023/01/23.
//

import UIKit

import SnapKit
import Then

final class SetProfileViewController: BaseViewController {
    // MARK: - property

    private let nicknameLabel = UILabel().then {
        $0.text = "닉네임"
        $0.font = UIFont.preferredFont(forTextStyle: .body, weight: .medium)
    }

    private let nicknameField = UITextField().then {
        let attributes = [
            NSAttributedString.Key.foregroundColor: UIColor.grey001,
            NSAttributedString.Key.font: UIFont.preferredFont(forTextStyle: .body, weight: .regular)
        ]

        $0.backgroundColor = .white
        $0.attributedPlaceholder = NSAttributedString(string: "8자 이내 한글 또는 영문", attributes: attributes)
        $0.autocapitalizationType = .none
        $0.layer.cornerRadius = 12
        $0.layer.masksToBounds = true
        $0.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 0))
        $0.leftViewMode = .always
        $0.clipsToBounds = false
        $0.clearButtonMode = .always
        $0.makeBorderLayer(color: .grey002)
    }

    private lazy var signUpButton = MainButton().then {
        $0.label.text = "완료"

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

    // MARK: - life cycle

    override func render() {
        view.addSubviews(nicknameLabel, nicknameField, signUpButton)

        nicknameLabel.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top).inset(20)
            $0.leading.equalToSuperview().inset(20)
        }

        nicknameField.snp.makeConstraints {
            $0.top.equalTo(nicknameLabel.snp.bottom).offset(10)
            $0.leading.trailing.equalToSuperview().inset(20)
            $0.height.equalTo(60)
        }

        signUpButton.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(20)
            $0.bottom.equalTo(view.safeAreaLayoutGuide).inset(20)
            $0.height.equalTo(60)
        }
    }

    override func setupNavigationBar() {
        super.setupNavigationBar()
        title = "프로필 설정"
    }
}
