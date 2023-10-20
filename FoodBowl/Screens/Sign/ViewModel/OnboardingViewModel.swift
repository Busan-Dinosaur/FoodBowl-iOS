//
//  OnboardingViewModel.swift
//  FoodBowl
//
//  Created by COBY_PRO on 2023/08/10.
//

import AuthenticationServices
import Combine
import UIKit

import CombineMoya
import Moya

final class OnboardingViewModel: NSObject, BaseViewModelType {
    
    // MARK: - property
    
    private let providerService = MoyaProvider<ServiceAPI>()
    private let providerMember = MoyaProvider<MemberAPI>()
    
    private var cancellable = Set<AnyCancellable>()
    
    private let isLoginSubject = PassthroughSubject<Bool, Error>()
    
    struct Input {
        let appleSignButtonDidTap: AnyPublisher<Void, Never>
    }
    
    struct Output {
        let isLogin: PassthroughSubject<Bool, Error>
    }
    
    func transform(from input: Input) -> Output {
        input.appleSignButtonDidTap
            .sink(receiveValue: { [weak self] _ in
                self?.didTapAppleSignButton()
            })
            .store(in: &self.cancellable)
        
        return Output(isLogin: self.isLoginSubject)
    }
    
    // MARK: - network
    
    private func getToken(appleToken: String) {
        providerService.requestPublisher(.signIn(request: SignRequest(appleToken: appleToken)))
            .sink { completion in
                switch completion {
                case let .failure(error) :
                    self.isLoginSubject.send(completion: .failure(error))
                case .finished :
                    self.getMyProfile()
                }
            } receiveValue: { recievedValue in
                guard let responseData = try? recievedValue.map(SignResponse.self) else { return }
                KeychainManager.set(responseData.accessToken, for: .accessToken)
                KeychainManager.set(responseData.refreshToken, for: .refreshToken)
                UserDefaultHandler.setIsLogin(isLogin: true)
            }
            .store(in : &cancellable)
    }
    
    private func getMyProfile() {
        providerMember.requestPublisher(.getMyProfile)
            .sink { completion in
                switch completion {
                case let .failure(error) :
                    self.isLoginSubject.send(completion: .failure(error))
                case .finished :
                    self.isLoginSubject.send(true)
                }
            } receiveValue: { recievedValue in
                guard let responseData = try? recievedValue.map(MemberProfileResponse.self) else { return }
                UserDefaultsManager.currentUser = responseData
            }
            .store(in : &cancellable)
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

extension OnboardingViewModel: ASAuthorizationControllerDelegate {
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        guard let credential = authorization.credential as? ASAuthorizationAppleIDCredential else { return }
        guard let token = credential.identityToken else { return }
        guard let tokenToString = String(data: token, encoding: .utf8) else { return }

        getToken(appleToken: tokenToString)
    }
}
