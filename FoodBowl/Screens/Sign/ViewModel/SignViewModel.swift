//
//  SignViewModel.swift
//  FoodBowl
//
//  Created by COBY_PRO on 2023/08/10.
//

import UIKit

import Moya

final class SignInViewModel {
    private let provider = MoyaProvider<ServiceAPI>()

    func signIn(appleToken: String) async {
        let response = await provider.request(.signIn(form: SignRequest(appleToken: appleToken)))
        switch response {
        case .success(let result):
            guard let data = try? result.map(SignResponse.self) else { return }
            KeychainManager.set(data.accessToken, for: .token)
            UserDefaultHandler.setIsLogin(isLogin: true)
        case .failure(let err):
            print(err.localizedDescription)
        }
    }
}
