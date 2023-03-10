//
//  SetProfileViewController.swift
//  FoodBowl
//
//  Created by COBY_PRO on 2023/01/23.
//

import UIKit

import SnapKit
import Then
import YPImagePicker

final class SetProfileViewController: BaseViewController {
    private var profileImage: UIImage = ImageLiteral.defaultProfile
    private var maxLength = 10

    // MARK: - property

    private lazy var profileImageView = UIImageView().then {
        $0.image = ImageLiteral.defaultProfile
        $0.layer.cornerRadius = 50
        $0.layer.masksToBounds = true
        $0.clipsToBounds = true
        $0.isUserInteractionEnabled = true
        $0.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tappedProfileImageView)))
    }

    private let nicknameLabel = UILabel().then {
        $0.text = "닉네임"
        $0.font = UIFont.preferredFont(forTextStyle: .body, weight: .medium)
        $0.textColor = .mainText
    }

    private lazy var nicknameField = UITextField().then {
        let attributes = [
            NSAttributedString.Key.foregroundColor: UIColor.grey001,
            NSAttributedString.Key.font: UIFont.preferredFont(forTextStyle: .body, weight: .regular)
        ]

        $0.backgroundColor = .clear
        $0.attributedPlaceholder = NSAttributedString(string: "10자 이내 한글 또는 영문", attributes: attributes)
        $0.autocapitalizationType = .none
        $0.layer.cornerRadius = 12
        $0.layer.masksToBounds = true
        $0.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 0))
        $0.leftViewMode = .always
        $0.clipsToBounds = false
        $0.clearButtonMode = .always
        $0.makeBorderLayer(color: .grey002)
        $0.delegate = self
    }

    private lazy var signUpButton = MainButton().then {
        $0.label.text = "완료"

        let action = UIAction { [weak self] _ in
            self?.tappedCompleteButton()
        }
        $0.addAction(action, for: .touchUpInside)
    }

    // MARK: - life cycle

    override func viewDidLoad() {
        super.viewDidLoad()

        NotificationCenter.default.addObserver(
            self,
            selector: #selector(textDidChange(_:)),
            name: UITextField.textDidChangeNotification,
            object: nicknameField
        )
    }

    override func setupLayout() {
        view.addSubviews(profileImageView, nicknameLabel, nicknameField, signUpButton)

        profileImageView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top).inset(20)
            $0.centerX.equalToSuperview()
            $0.width.height.equalTo(100)
        }

        nicknameLabel.snp.makeConstraints {
            $0.top.equalTo(profileImageView.snp.bottom).offset(20)
            $0.leading.equalToSuperview().inset(20)
        }

        nicknameField.snp.makeConstraints {
            $0.top.equalTo(nicknameLabel.snp.bottom).offset(10)
            $0.leading.trailing.equalToSuperview().inset(20)
            $0.height.equalTo(60)
        }

        signUpButton.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(20)
            $0.bottom.equalTo(view.safeAreaLayoutGuide).inset(10)
            $0.height.equalTo(60)
        }
    }

    override func setupNavigationBar() {
        super.setupNavigationBar()
        title = "프로필 설정"
    }

    @objc
    private func tappedProfileImageView(_: UITapGestureRecognizer) {
        var config = YPImagePickerConfiguration()
        config.onlySquareImagesFromCamera = true
        config.library.defaultMultipleSelection = false
        config.library.mediaType = .photo
        config.startOnScreen = YPPickerScreen.library
        config.shouldSaveNewPicturesToAlbum = true
        config.albumName = "FoodBowl"

        let titleAttributes = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 17, weight: .regular)]
        let barButtonAttributes = [NSAttributedString.Key.font: UIFont.preferredFont(forTextStyle: .headline, weight: .regular)]
        UINavigationBar.appearance().titleTextAttributes = titleAttributes // Title fonts
        UIBarButtonItem.appearance().setTitleTextAttributes(barButtonAttributes, for: .normal) // Bar Button fonts
        config.wordings.libraryTitle = "갤러리"
        config.wordings.cameraTitle = "카메라"
        config.wordings.next = "다음"
        config.wordings.cancel = "취소"
        config.colors.tintColor = .mainPink

        let picker = YPImagePicker(configuration: config)

        picker.didFinishPicking { [unowned picker] items, cancelled in
            if !cancelled {
                let images: [UIImage] = items.compactMap { item in
                    if case .photo(let photo) = item {
                        return photo.image
                    } else {
                        return nil
                    }
                }
                self.profileImage = images[0]
                self.profileImageView.image = images[0]
            }
            picker.dismiss(animated: true, completion: nil)
        }
        present(picker, animated: true, completion: nil)
    }

    @objc
    private func textDidChange(_ notification: Notification) {
        if let textField = notification.object as? UITextField {
            if let text = textField.text {
                if text.count > maxLength {
                    textField.resignFirstResponder()
                }

                if text.count >= maxLength {
                    let index = text.index(text.startIndex, offsetBy: maxLength)
                    let newString = text[text.startIndex ..< index]
                    textField.text = String(newString)
                }
            }
        }
    }

    private func tappedCompleteButton() {
        if nicknameField.text?.count != 0 {
            let tabbarViewController = UINavigationController(rootViewController: TabBarController())
            tabbarViewController.modalPresentationStyle = .fullScreen
            tabbarViewController.modalTransitionStyle = .crossDissolve
            DispatchQueue.main.async {
                self.present(tabbarViewController, animated: true)
            }
        } else {
            let alert = UIAlertController(title: nil, message: "사용할 닉네임을 입력해주세요", preferredStyle: .alert)
            let cancel = UIAlertAction(title: "닫기", style: .cancel, handler: nil)

            alert.addAction(cancel)

            DispatchQueue.main.async {
                self.present(alert, animated: true, completion: nil)
            }
        }
    }
}
