//
//  UpdateProfileViewController.swift
//  FoodBowl
//
//  Created by COBY_PRO on 2023/01/26.
//

import UIKit

import Kingfisher
import SnapKit
import Then
import YPImagePicker

final class UpdateProfileViewController: BaseViewController {
    
    // MARK: - property
    
    private var viewModel = MapViewModel()
    
    // MARK: - ui component
    
    private let scrollView = UIScrollView().then {
        $0.isScrollEnabled = true
        $0.showsVerticalScrollIndicator = false
    }
    private let contentView = UIView()
    private lazy var profileImageView = UIImageView().then {
        $0.layer.cornerRadius = 50
        $0.layer.masksToBounds = true
        $0.layer.borderColor = UIColor.grey002.cgColor
        $0.layer.borderWidth = 1
        $0.isUserInteractionEnabled = true
        $0.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tappedProfileImageView)))
    }
    private let nicknameLabel = UILabel().then {
        $0.text = "닉네임"
        $0.font = .font(.regular, ofSize: 17)
        $0.textColor = .mainTextColor
    }
    private lazy var nicknameField = UITextField().then {
        let attributes = [
            NSAttributedString.Key.foregroundColor: UIColor.grey001,
            NSAttributedString.Key.font: UIFont.preferredFont(forTextStyle: .subheadline, weight: .regular)
        ]

        $0.backgroundColor = .clear
        $0.attributedPlaceholder = NSAttributedString(string: "10자 이내 한글 또는 영문", attributes: attributes)
        $0.autocapitalizationType = .none
        $0.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 0))
        $0.leftViewMode = .always
        $0.clearButtonMode = .always
        $0.font = UIFont.preferredFont(forTextStyle: .subheadline, weight: .regular)
        $0.textColor = .mainTextColor
        $0.delegate = self
        $0.makeBorderLayer(color: .grey002)
    }
    private let userInfoLabel = UILabel().then {
        $0.text = "한줄 소개"
        $0.font = .font(.regular, ofSize: 17)
        $0.textColor = .mainTextColor
    }
    private lazy var userInfoField = UITextField().then {
        let attributes = [
            NSAttributedString.Key.foregroundColor: UIColor.grey001,
            NSAttributedString.Key.font: UIFont.preferredFont(forTextStyle: .subheadline, weight: .regular)
        ]

        $0.backgroundColor = .clear
        $0.attributedPlaceholder = NSAttributedString(string: "20자 이내 한글 또는 영문", attributes: attributes)
        $0.autocapitalizationType = .none
        $0.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 0))
        $0.leftViewMode = .always
        $0.clearButtonMode = .always
        $0.font = UIFont.preferredFont(forTextStyle: .subheadline, weight: .regular)
        $0.textColor = .mainTextColor
        $0.delegate = self
        $0.makeBorderLayer(color: .grey002)
    }
    private lazy var completeButton = MainButton().then {
        $0.label.text = "완료"
        let action = UIAction { [weak self] _ in
            self?.tappedCompleteButton()
        }
        $0.addAction(action, for: .touchUpInside)
    }
    
    // MARK: - life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupProfile()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabBarController?.tabBar.isHidden = true
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        tabBarController?.tabBar.isHidden = false
    }

    override func setupLayout() {
        view.addSubviews(scrollView, completeButton)
        
        scrollView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            $0.bottom.equalTo(completeButton.snp.top).offset(-20)
            $0.leading.trailing.equalToSuperview()
        }
        
        scrollView.addSubview(contentView)
        
        contentView.snp.makeConstraints {
            $0.width.equalToSuperview()
            $0.top.bottom.equalToSuperview()
        }
        
        contentView.addSubviews(profileImageView, nicknameLabel, nicknameField, userInfoLabel, userInfoField)

        profileImageView.snp.makeConstraints {
            $0.top.equalToSuperview().inset(20)
            $0.centerX.equalToSuperview()
            $0.width.height.equalTo(100)
        }

        nicknameLabel.snp.makeConstraints {
            $0.top.equalTo(profileImageView.snp.bottom).offset(40)
            $0.leading.equalToSuperview().inset(SizeLiteral.horizantalPadding)
        }

        nicknameField.snp.makeConstraints {
            $0.top.equalTo(nicknameLabel.snp.bottom).offset(10)
            $0.leading.trailing.equalToSuperview().inset(SizeLiteral.horizantalPadding)
            $0.height.equalTo(50)
        }

        userInfoLabel.snp.makeConstraints {
            $0.top.equalTo(nicknameField.snp.bottom).offset(30)
            $0.leading.equalToSuperview().inset(SizeLiteral.horizantalPadding)
        }

        userInfoField.snp.makeConstraints {
            $0.top.equalTo(userInfoLabel.snp.bottom).offset(10)
            $0.leading.trailing.equalToSuperview().inset(SizeLiteral.horizantalPadding)
            $0.height.equalTo(50)
            $0.bottom.equalToSuperview()
        }

        completeButton.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(SizeLiteral.horizantalPadding)
            $0.bottom.equalToSuperview().inset(SizeLiteral.bottomPadding)
            $0.height.equalTo(60)
        }
    }

    override func setupNavigationBar() {
        super.setupNavigationBar()
        title = "프로필 수정"
    }

    private func setupProfile() {
        nicknameField.text = UserDefaultsManager.currentUser?.nickname
        userInfoField.text = UserDefaultsManager.currentUser?.introduction

        if let url = UserDefaultsManager.currentUser?.profileImageUrl {
            profileImageView.kf.setImage(with: URL(string: url))
        } else {
            profileImageView.image = ImageLiteral.defaultProfile
        }
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
                self.profileImageView.image = images[0]
            }
            picker.dismiss(animated: true, completion: nil)
        }
        present(picker, animated: true, completion: nil)
    }

    private func tappedCompleteButton() {
        if let nickname = nicknameField.text, let introduction = userInfoField.text {
            if nickname.count != 0 && introduction.count != 0 {
                let updatedProfile = UpdateMemberProfileRequestDTO(nickname: nickname, introduction: introduction)
                Task {
                    animationView!.isHidden = false
                    await viewModel.updateMembeProfile(profile: updatedProfile)
                    if let image = profileImageView.image {
                        await viewModel.updateMembeProfileImage(image: image)
                    }
                    animationView!.isHidden = true
                    navigationController?.popViewController(animated: true)
                }
            } else {
                let alert = UIAlertController(title: nil, message: "닉네임과 한줄 소개를 입력해주세요", preferredStyle: .alert)
                let cancel = UIAlertAction(title: "닫기", style: .cancel, handler: nil)

                alert.addAction(cancel)

                present(alert, animated: true, completion: nil)
            }
        }
    }
}

extension UpdateProfileViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        var maxLength = 0
        
        // 길이 제한을 설정
        if textField == nicknameField {
            maxLength = 10
        } else if textField == userInfoField {
            maxLength = 20
        }
        
        // 새로운 텍스트와 길이 제한 검사
        let currentText = textField.text ?? ""
        let newText = (currentText as NSString).replacingCharacters(in: range, with: string)
        
        if newText.count > maxLength {
            // 최대 길이에 도달했을 때 알림 표시
            makeAlert(title: "최대 \(maxLength)자까지 입력 가능합니다.")
            return false
        }
        
        return true
    }
}
