//
//  SceneDelegate.swift
//  FoodBowl
//
//  Created by COBY_PRO on 2022/12/23.
//

import UIKit

import Moya

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    
    typealias Task = _Concurrency.Task
    
    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo _: UISceneSession, options _: UIScene.ConnectionOptions) {
        self.renewToken()
        
        guard let windowScene = (scene as? UIWindowScene) else { return }
        window = UIWindow(windowScene: windowScene)

        LocationManager.shared.checkLocationService()
        
        let repository = SignRepositoryImpl()
        let usecase = SignUsecaseImpl(repository: repository)
        let viewModel = SignViewModel(usecase: usecase)
        let viewController = SignViewController(viewModel: viewModel)

        window?.rootViewController = UINavigationController(
            rootViewController: UserDefaultStorage.isLogin ? TabBarController() : viewController
        )
        window?.makeKeyAndVisible()
    }

    func sceneDidDisconnect(_: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not necessarily discarded (see `application:didDiscardSceneSessions` instead).
    }

    func sceneDidBecomeActive(_: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
    }

    func sceneWillResignActive(_: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }

    func sceneWillEnterForeground(_: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }

    func sceneDidEnterBackground(_: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.
    }
}

extension SceneDelegate {
    func renewToken() {
        let accessToken: String = KeychainManager.get(.accessToken)
        let refreshToken: String = KeychainManager.get(.refreshToken)
        
        let provider = MoyaProvider<SignAPI>()
        provider.request(.patchRefreshToken(token: Token(
            accessToken: accessToken,
            refreshToken: refreshToken
        ))) { result in
            switch result {
            case .success(let response):
                guard let token = try? JSONDecoder().decode(Token.self, from: response.data) else { return }
                
                KeychainManager.set(token.accessToken, for: .accessToken)
                KeychainManager.set(token.refreshToken, for: .refreshToken)
                UserDefaultHandler.setIsLogin(isLogin: true)
                
                let expiryDate = Date().addingTimeInterval(1800)
                UserDefaultHandler.setTokenExpiryDate(tokenExpiryDate: expiryDate)
            case .failure:
                KeychainManager.clear()
                UserDefaultHandler.clearAllData()
            }
        }
    }
    
    func logOut() {
        Task {
            let provider = MoyaProvider<SignAPI>()
            let result = await provider.request(.logOut)
            
            switch result {
            case .success:
                self.moveToSignViewController()
            case .failure(let error):
                guard let rootVC = (UIApplication.shared.connectedScenes.first as? UIWindowScene)?.windows.first?.rootViewController
                else { return }
                
                rootVC.makeErrorAlert(
                    title: "에러",
                    error: error
                ) { _ in
                    self.moveToSignViewController()
                }
            }
        }
    }
    
    func signOut() {
        Task {
            let provider = MoyaProvider<SignAPI>()
            let result = await provider.request(.signOut)
            
            switch result {
            case .success:
                self.moveToSignViewController()
            case .failure(let error):
                guard let rootVC = (UIApplication.shared.connectedScenes.first as? UIWindowScene)?.windows.first?.rootViewController
                else { return }
                
                rootVC.makeErrorAlert(
                    title: "에러",
                    error: error
                ) { _ in
                    self.moveToSignViewController()
                }
            }
        }
    }
    
    func moveToSignViewController() {
        KeychainManager.clear()
        UserDefaultHandler.clearAllData()
        
        let repository = SignRepositoryImpl()
        let usecase = SignUsecaseImpl(repository: repository)
        let viewModel = SignViewModel(usecase: usecase)
        let viewController = SignViewController(viewModel: viewModel)
        window?.rootViewController = UINavigationController(rootViewController: viewController)
    }
}
