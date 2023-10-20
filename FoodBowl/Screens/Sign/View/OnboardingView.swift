//
//  OnboardingView.swift
//  FoodBowl
//
//  Created by COBY_PRO on 10/20/23.
//

import AuthenticationServices
import Combine
import UIKit

import SnapKit
import Then

protocol OnboardingViewDelegate: AnyObject {
    func didTapAppleSignButton()
}

final class OnboardingView: UIView, BaseViewType {
    
    // MARK: - ui component
    
    private let titleLabel = UILabel().then {
        $0.font = .font(.regular, ofSize: 50)
        $0.textColor = .mainTextColor
        $0.text = "FoodBowl"
    }
    private let subTitleLabel = UILabel().then {
        $0.font = .font(.regular, ofSize: 30)
        $0.textColor = .mainTextColor
        $0.text = "Just Do Eat"
    }
    private let guideLabel = UILabel().then {
        $0.font = UIFont.preferredFont(forTextStyle: .title3, weight: .medium)
        $0.textColor = .mainTextColor
        $0.text = "친구들과 함께 만들어가는 맛집지도"
    }
    private lazy var appleSignButton = ASAuthorizationAppleIDButton(
        type: .signIn,
        style: traitCollection.userInterfaceStyle == .dark ? .white : .black
    ).then {
        $0.cornerRadius = 30
    }
    
    let appleSignButtonDidTapPublisher = PassthroughSubject<Void, Never>()
    
    // MARK: - property
    
    private weak var delegate: OnboardingViewDelegate?
    
    // MARK: - init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.baseInit()
        self.setupAction()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - base func
    
    func setupLayout() {
        self.addSubviews(titleLabel, subTitleLabel, guideLabel, appleSignButton)

        titleLabel.snp.makeConstraints {
            $0.top.equalTo(self.safeAreaLayoutGuide.snp.top).inset(100)
            $0.centerX.equalToSuperview()
        }

        subTitleLabel.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(40)
            $0.centerX.equalToSuperview()
        }

        guideLabel.snp.makeConstraints {
            $0.top.equalTo(subTitleLabel.snp.bottom).offset(100)
            $0.centerX.equalToSuperview()
        }

        appleSignButton.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(BaseSize.horizantalPadding)
            $0.bottom.equalToSuperview().inset(BaseSize.bottomPadding)
            $0.height.equalTo(60)
        }
    }
    
    func configureUI() {
        self.backgroundColor = .mainBackgroundColor
    }

    // MARK: - func

    private func setupAction() {
        let action = UIAction { [weak self] _ in
            self?.appleSignButtonDidTapPublisher.send()
        }
        self.appleSignButton.addAction(action, for: .touchUpInside)
    }
    
    func configureDelegate(_ delegate: OnboardingViewDelegate) {
        self.delegate = delegate
    }
}
