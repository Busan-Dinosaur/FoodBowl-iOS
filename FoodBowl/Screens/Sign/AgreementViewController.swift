//
//  AgreementViewController.swift
//  FoodBowl
//
//  Created by COBY_PRO on 2023/01/27.
//

import UIKit

import SnapKit
import Then

final class AgreementViewController: BaseViewController {
    // MARK: - property

    private lazy var mainAgreeButton = UIButton().then {
        $0.setTitle("전체 동의", for: .normal)
        $0.setTitleColor(.mainText, for: .normal)
        $0.titleLabel?.font = .preferredFont(forTextStyle: .title3, weight: .medium)
        let action = UIAction { [weak self] _ in
            self?.tappedMainAgreeButton()
        }
        $0.addAction(action, for: .touchUpInside)
    }

    private lazy var mainCheckBox = CheckBox().then {
        $0.style = .tick
        $0.addTarget(self, action: #selector(onMainCheckBoxValueChange(_:)), for: .valueChanged)
    }

    private lazy var subAgreeLabel1 = UIButton().then {
        $0.setTitle("개인정보처리방침 (필수)", for: .normal)
        $0.setTitleColor(.subText, for: .normal)
        $0.titleLabel?.font = .preferredFont(forTextStyle: .body, weight: .regular)
        $0.setUnderline()
        let action = UIAction { [weak self] _ in
            let showWebViewController = ShowWebViewController()
            showWebViewController.title = "개인정보처리방침"
            showWebViewController.url = "https://coby5502.notion.site/2ca079dd7b354cd790b3280728ebb0d5"
            let navigationController = UINavigationController(rootViewController: showWebViewController)
            navigationController.modalPresentationStyle = .fullScreen
            DispatchQueue.main.async {
                self?.present(navigationController, animated: true)
            }
        }
        $0.addAction(action, for: .touchUpInside)
    }

    private lazy var subCheckBox1 = CheckBox().then {
        $0.style = .tick
        $0.addTarget(self, action: #selector(onSubCheckBox1ValueChange(_:)), for: .valueChanged)
    }

    private lazy var subAgreeLabel2 = UIButton().then {
        $0.setTitle("이용약관 (필수)", for: .normal)
        $0.setTitleColor(.subText, for: .normal)
        $0.titleLabel?.font = .preferredFont(forTextStyle: .body, weight: .regular)
        $0.setUnderline()
        let action = UIAction { [weak self] _ in
            let showWebViewController = ShowWebViewController()
            showWebViewController.title = "이용약관"
            showWebViewController.url = "https://coby5502.notion.site/32da9811cd284eaab7c3d8390c0ddccc"
            let navigationController = UINavigationController(rootViewController: showWebViewController)
            navigationController.modalPresentationStyle = .fullScreen
            DispatchQueue.main.async {
                self?.present(navigationController, animated: true)
            }
        }
        $0.addAction(action, for: .touchUpInside)
    }

    private lazy var subCheckBox2 = CheckBox().then {
        $0.style = .tick
        $0.addTarget(self, action: #selector(onSubCheckBox2ValueChange(_:)), for: .valueChanged)
    }

    private lazy var nextButton = MainButton().then {
        $0.label.text = "다음"
        let action = UIAction { [weak self] _ in
            self?.tappedNextButton()
        }
        $0.addAction(action, for: .touchUpInside)
    }

    // MARK: - life cycle

    override func setupLayout() {
        view.addSubviews(mainAgreeButton, mainCheckBox, subAgreeLabel1, subCheckBox1, subAgreeLabel2, subCheckBox2, nextButton)

        mainAgreeButton.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top).inset(20)
            $0.leading.equalToSuperview().inset(20)
        }

        mainCheckBox.snp.makeConstraints {
            $0.centerY.equalTo(mainAgreeButton)
            $0.trailing.equalToSuperview().inset(20)
            $0.width.height.equalTo(24)
        }

        subAgreeLabel1.snp.makeConstraints {
            $0.top.equalTo(mainAgreeButton.snp.bottom).offset(40)
            $0.leading.equalToSuperview().inset(20)
        }

        subCheckBox1.snp.makeConstraints {
            $0.centerY.equalTo(subAgreeLabel1)
            $0.trailing.equalToSuperview().inset(20)
            $0.width.height.equalTo(24)
        }

        subAgreeLabel2.snp.makeConstraints {
            $0.top.equalTo(subAgreeLabel1.snp.bottom).offset(10)
            $0.leading.equalToSuperview().inset(20)
        }

        subCheckBox2.snp.makeConstraints {
            $0.centerY.equalTo(subAgreeLabel2)
            $0.trailing.equalToSuperview().inset(20)
            $0.width.height.equalTo(24)
        }

        nextButton.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(20)
            $0.bottom.equalTo(view.safeAreaLayoutGuide).inset(20)
            $0.height.equalTo(60)
        }
    }

    override func setupNavigationBar() {
        super.setupNavigationBar()
        title = "약관 동의"
    }

    private func tappedMainAgreeButton() {
        mainCheckBox.isChecked = !mainCheckBox.isChecked
        if mainCheckBox.isChecked {
            subCheckBox1.isChecked = true
            subCheckBox2.isChecked = true
        } else {
            subCheckBox1.isChecked = false
            subCheckBox2.isChecked = false
        }
    }

    @objc
    private func onMainCheckBoxValueChange(_ sender: CheckBox) {
        if sender.isChecked {
            subCheckBox1.isChecked = true
            subCheckBox2.isChecked = true
        } else {
            subCheckBox1.isChecked = false
            subCheckBox2.isChecked = false
        }
    }

    @objc
    private func onSubCheckBox1ValueChange(_ sender: CheckBox) {
        if sender.isChecked && subCheckBox2.isChecked {
            mainCheckBox.isChecked = true
        } else {
            mainCheckBox.isChecked = false
        }
    }

    @objc
    private func onSubCheckBox2ValueChange(_ sender: CheckBox) {
        if sender.isChecked && subCheckBox1.isChecked {
            mainCheckBox.isChecked = true
        } else {
            mainCheckBox.isChecked = false
        }
    }

    private func tappedNextButton() {
        if mainCheckBox.isChecked {
            let setProfileViewController = SetProfileViewController()
            navigationController?.pushViewController(setProfileViewController, animated: true)
        } else {
            let alert = UIAlertController(title: nil, message: "모든 약관에 동의를 해주세요", preferredStyle: .alert)
            let cancel = UIAlertAction(title: "닫기", style: .cancel, handler: nil)

            alert.addAction(cancel)

            present(alert, animated: true, completion: nil)
        }
    }
}
