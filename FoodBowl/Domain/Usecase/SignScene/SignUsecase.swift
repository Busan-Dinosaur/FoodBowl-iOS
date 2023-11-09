//
//  SignUsecase.swift
//  FoodBowl
//
//  Created by COBY_PRO on 11/9/23.
//

import Foundation

import Moya

//protocol SignUsecase {
//    func dispatchAppleLogin(login: LoginRequestDTO) async throws -> Login
//}
//
//final class SignUsecaseImpl: SignUsecase {
//    
//    // MARK: - property
//    
//    private let providerService = MoyaProvider<ServiceAPI>()
//    private let providerMember = MoyaProvider<MemberAPI>()
//    
//    // MARK: - Public - func
//    
//    func getToken(signRequest: SignRequest) async throws -> SignDTO {
//        do {
//            let signResponse = try await self.providerService.request(.signIn(request: signRequest))
//            return signResponse
//        } catch {
//            
//        }
//    }
//    
//    func dispatchAppleLogin(login: LoginRequestDTO) async throws -> Login {
//        do {
//            let loginDTO = try await self.repository.dispatchAppleLogin(login: login)
//            return loginDTO.toLogin()
//        } catch {
//            throw LoginUsecaseError.failedToLogin
//        }
//    }
//}
