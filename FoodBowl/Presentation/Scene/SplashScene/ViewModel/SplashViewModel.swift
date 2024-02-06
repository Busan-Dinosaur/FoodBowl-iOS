//
//  SplashViewModel.swift
//  FoodBowl
//
//  Created by Coby on 2/1/24.
//

import Combine
import Foundation

final class SplashViewModel: NSObject, BaseViewModelType {
    
    // MARK: - property
    
    private let usecase: SplashUsecase
    private var cancellable: Set<AnyCancellable> = Set()
    
    private let isLoginSubject: PassthroughSubject<Bool, Never> = PassthroughSubject()
    
    struct Input {
        let viewDidLoad: AnyPublisher<Void, Never>
    }
    
    struct Output {
        let isLogin: AnyPublisher<Bool, Never>
    }
    
    func transform(from input: Input) -> Output {
        input.viewDidLoad
            .sink(receiveValue: { [weak self] _ in
                guard let self = self else { return }
                self.patchRefreshToken()
            })
            .store(in: &self.cancellable)
        
        return Output(
            isLogin: self.isLoginSubject.eraseToAnyPublisher()
        )
    }
    
    // MARK: - init
    
    init(usecase: SplashUsecase) {
        self.usecase = usecase
    }

    // MARK: - network
    
    private func patchRefreshToken() {
        Task {
            do {
                if UserDefaultStorage.isLogin {
                    let accessToken: String = KeychainManager.get(.accessToken)
                    let refreshToken: String = KeychainManager.get(.refreshToken)
                    
                    let token = try await self.usecase.patchRefreshToken(token: Token(
                        accessToken: accessToken,
                        refreshToken: refreshToken
                    ))
                    
                    KeychainManager.set(token.accessToken, for: .accessToken)
                    KeychainManager.set(token.refreshToken, for: .refreshToken)
                    
                    let expiryDate = Date().addingTimeInterval(1800)
                    UserDefaultHandler.setTokenExpiryDate(tokenExpiryDate: expiryDate)
                    
                    self.isLoginSubject.send(true)
                } else {
                    KeychainManager.clear()
                    UserDefaultHandler.clearAllData()
                    
                    self.isLoginSubject.send(false)
                }
            } catch {
                KeychainManager.clear()
                UserDefaultHandler.clearAllData()
                
                self.isLoginSubject.send(false)
            }
        }
    }
}
