//
//  SignViewModel.swift
//  FoodBowl
//
//  Created by COBY_PRO on 2023/08/10.
//

import AuthenticationServices
import Combine
import UIKit

import CombineMoya
import Moya

final class SignViewModel: NSObject, BaseViewModelType {
    
    // MARK: - property
    
    private let providerService = MoyaProvider<ServiceAPI>()
    private let providerMember = MoyaProvider<MemberAPI>()
    
    private var cancellable = Set<AnyCancellable>()
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
    
    // MARK: - network
    
    private func getToken(appleToken: String) {
        providerService.requestPublisher(.signIn(request: SignRequest(appleToken: appleToken)))
            .sink { completion in
                switch completion {
                case let .failure(error) :
                    print("LogIn Fail : " + error.localizedDescription)
                case .finished :
                    print("LogIn Finished")
                }
            } receiveValue: { recievedValue in
                guard let responseData = try? recievedValue.map(SignResponse.self) else { return }
                print(responseData)
            }.store(in : &cancellable)
    }
    
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
        guard let token = credential.identityToken else { return }
        guard let tokenToString = String(data: token, encoding: .utf8) else { return }

        getToken(appleToken: tokenToString)
    }
}
