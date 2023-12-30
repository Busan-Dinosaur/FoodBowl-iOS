//
//  SignViewController.swift
//  FoodBowl
//
//  Created by COBY_PRO on 2023/01/23.
//

import AuthenticationServices
import Combine
import UIKit

import SnapKit
import Then

final class SignViewController: UIViewController {
    
    // MARK: - ui component
    
    private let signView: SignView = SignView()
    
    // MARK: - property
    
    private let viewModel: any BaseViewModelType
    private var cancellable: Set<AnyCancellable> = Set()
    
    // MARK: - init
    
    init(viewModel: any BaseViewModelType) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        print("\(#file) is dead")
    }
    
    // MARK: - life cycle
    
    override func loadView() {
        self.view = self.signView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.bindViewModel()
    }

    // MARK: - func
    
    private func bindViewModel() {
        let output = self.transformedOutput()
        self.bindOutputToViewModel(output)
    }
    
    private func transformedOutput() -> SignViewModel.Output? {
        guard let viewModel = self.viewModel as? SignViewModel else { return nil }
        let input = SignViewModel.Input(
            appleSignButtonDidTap: self.signView.appleSignButtonTapPublisher.eraseToAnyPublisher()
        )
        return viewModel.transform(from: input)
    }
    
    private func bindOutputToViewModel(_ output: SignViewModel.Output?) {
        guard let output else { return }
        
        output.isLogin
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { [weak self] result in
                switch result {
                case .success:
                    self?.presentTapBarController()
                case .failure(let error):
                    self?.makeAlert(
                        title: "로그인 에러",
                        message: error.localizedDescription
                    )
                }
            })
            .store(in: &self.cancellable)
    }
}

// MARK: - Helper
extension SignViewController {
    private func presentTapBarController() {
        let tabbarViewController = UINavigationController(rootViewController: TabBarController())
        tabbarViewController.modalPresentationStyle = .fullScreen
        tabbarViewController.modalTransitionStyle = .crossDissolve
        self.present(tabbarViewController, animated: true)
    }
}
