//
//  SignService.swift
//  FoodBowl
//
//  Created by COBY_PRO on 10/20/23.
//

import AuthenticationServices

import Moya

protocol SignSevicable {
    func getToken(appleToken: String) async throws -> Void
    func getMyProfile() async throws -> Void
}

final class SignService: SignSevicable {
    
    private let providerService = MoyaProvider<ServiceAPI>()
    private let providerMember = MoyaProvider<MemberAPI>()
    
    func getToken(appleToken: String) async {
        let response = await providerService.request(.signIn(request: SignRequest(appleToken: appleToken)))
        switch response {
        case .success(let result):
            guard let data = try? result.map(SignResponse.self) else { return }
            KeychainManager.set(data.accessToken, for: .accessToken)
            KeychainManager.set(data.refreshToken, for: .refreshToken)
            UserDefaultHandler.setIsLogin(isLogin: true)
        case .failure(let err):
            handleError(err)
        }
    }

    func getMyProfile() async {
        let response = await providerMember.request(.getMyProfile)
        switch response {
        case .success(let result):
            guard let data = try? result.map(MemberProfileResponse.self) else { return }
            UserDefaultsManager.currentUser = data
        case .failure(let err):
            handleError(err)
        }
    }
    
    func handleError(_ error: MoyaError) {
        if let errorResponse = error.errorResponse {
            print("에러 코드: \(errorResponse.errorCode)")
            print("에러 메시지: \(errorResponse.message)")
        } else {
            print("네트워크 에러: \(error.localizedDescription)")
        }
    }
}
