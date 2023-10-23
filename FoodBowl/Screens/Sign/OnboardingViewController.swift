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
    
    private var cancelBag: Set<AnyCancellable> = Set()
    private let viewModel = OnboardingViewModel()
    
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
        self.bindViewModel()
        self.setupNavigation()
        self.setupKeyboardGesture()
    }

    // MARK: - func

    private func setupNavigationBarHiddenState() {
        self.navigationController?.navigationBar.isHidden = true
    }
    
    private func bindViewModel() {
        let output = self.transformedOutput()
        self.bindOutputToViewModel(output)
    }
    
    private func transformedOutput() -> OnboardingViewModel.Output {
        let input = OnboardingViewModel.Input(
            appleSignButtonDidTap: self.onboardingView.appleSignButtonDidTapPublisher.eraseToAnyPublisher()
        )
        return self.viewModel.transform(from: input)
    }
    
    private func bindOutputToViewModel(_ output: OnboardingViewModel.Output) {
        output.isLogin
            .receive(on: DispatchQueue.main)
            .sink { [weak self] result in
                switch result {
                case .failure:
                    self?.makeAlert(title: "로그인에 실패하셨습니다.")
                case .finished: return
                }
            } receiveValue: { [weak self] _ in
                let tabbarViewController = UINavigationController(rootViewController: TabBarController())
                tabbarViewController.modalPresentationStyle = .fullScreen
                tabbarViewController.modalTransitionStyle = .crossDissolve
                self?.present(tabbarViewController, animated: true)
            }
            .store(in: &self.cancelBag)
    }
}
