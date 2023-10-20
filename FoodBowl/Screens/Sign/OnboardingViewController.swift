//
//  OnboardingViewController.swift
//  FoodBowl
//
//  Created by COBY_PRO on 2023/01/23.
//

import AuthenticationServices
import Combine
import UIKit

import SnapKit
import Then

final class OnboardingViewController: UIViewController, Navigationable, Keyboardable {
    
    // MARK: - ui component
    
    private let onboardingView: OnboardingView = OnboardingView()
    
    // MARK: - property
    
    private var cancellable = Set<AnyCancellable>()
    private let signViewModel = SignViewModel()
    
    // MARK: - init
    
    deinit {
        print("\(#file) is dead")
    }
    
    // MARK: - life cycle
    
    override func loadView() {
        self.view = self.onboardingView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupNavigationBarHiddenState()
        self.configureDelegation()
        self.bindViewModel()
        self.setupNavigation()
        self.setupKeyboardGesture()
    }

    // MARK: - func

    private func setupNavigationBarHiddenState() {
        self.navigationController?.navigationBar.isHidden = true
    }
    
    private func configureDelegation() {
        self.onboardingView.configureDelegate(self)
    }
    
    private func bindViewModel() {
        let output = self.transformedOutput()
        self.bindOutputToViewModel(output)
    }
    
    private func transformedOutput() -> SignViewModel.Output {
        let input = SignViewModel.Input(
            appleSignButtonTap: self.onboardingView.appleSignButtonDidTapPublisher.eraseToAnyPublisher()
        )
        return self.signViewModel.transform(from: input)
    }
    
    private func bindOutputToViewModel(_ output: SignViewModel.Output) {
    }
}

extension OnboardingViewController: OnboardingViewDelegate {
    func didTapAppleSignButton() {
        print("버튼 누름")
    }
}
