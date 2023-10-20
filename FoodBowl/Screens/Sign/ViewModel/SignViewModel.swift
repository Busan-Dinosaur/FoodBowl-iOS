//
//  SignViewModel.swift
//  FoodBowl
//
//  Created by COBY_PRO on 2023/08/10.
//

import AuthenticationServices
import Combine
import UIKit

import Moya

final class SignViewModel: NSObject, BaseViewModelType {
    
    // MARK: - property
    
    private let signService: SignSevicable
    private var cancellable = Set<AnyCancellable>()
    private let loginPublisher = PassthroughSubject<Void, Error>()
    private let getToken = PassthroughSubject<Void, Error>()
    
    struct Input {
        let appleSignButtonTap: AnyPublisher<Void, Never>
    }
    
    struct Output {
    }
    
    func transform(from input: Input) -> Output {
        input.appleSignButtonTap
            .sink(receiveValue: { [weak self] _ in
                print("button tap")
                self?.didTapAppleSignButton()
            })
            .store(in: &self.cancellable)
        
        return Output()
    }
    
    // MARK: - init
    
    init(signService: SignSevicable) {
        self.signService = signService
    }
    
    // MARK: - network
//    private func getToken(appleToken: String) {
//        Task {
//            await self.signService.getToken(appleToken: appleToken)
//        }
//    }
    
    private func didTapAppleSignButton() {
        let provider = ASAuthorizationAppleIDProvider()
        let request = provider.createRequest()
        
        @Configurations(key: ConfigurationsKey.nonce, defaultValue: "")
        var nonce: String

        request.requestedScopes = [.fullName, .email]
        request.nonce = nonce.sha256

        let controller = ASAuthorizationController(authorizationRequests: [request])
        controller.delegate = self
        controller.performRequests()
    }
}

extension SignViewModel: ASAuthorizationControllerDelegate {
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        guard let credential = authorization.credential as? ASAuthorizationAppleIDCredential else { return }
        print(credential.user)
        loginPublisher.send()
    }

    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        loginPublisher.send(completion: .failure(error))
    }
}
