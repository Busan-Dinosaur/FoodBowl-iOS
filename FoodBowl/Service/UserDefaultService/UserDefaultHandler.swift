//
//  UserDefaultHandler.swift
//  FoodBowl
//
//  Created by COBY_PRO on 2023/02/01.
//

import Foundation

struct UserDefaultHandler {
    static func clearAllData() {
        UserData<Any>.clearAll()
    }

    static func setIsLogin(isLogin: Bool) {
        UserData.setValue(isLogin, forKey: .isLogin)
    }

    static func setAccessToken(accessToken: String) {
        UserData.setValue(accessToken, forKey: .accessToken)
    }

    static func setRefreshToken(refreshToken: String) {
        UserData.setValue(refreshToken, forKey: .refreshToken)
    }
}
