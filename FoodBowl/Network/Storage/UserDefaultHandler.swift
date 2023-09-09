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

    static func setUserID(userID: Int) {
        UserData.setValue(userID, forKey: .userID)
    }

    static func setAccessToken(accessToken: String) {
        UserData.setValue(accessToken, forKey: .accessToken)
    }

    static func setRefreshToken(refreshToken: String) {
        UserData.setValue(refreshToken, forKey: .refreshToken)
    }

    static func setNickname(nickname: String) {
        UserData.setValue(nickname, forKey: .nickname)
    }

    static func setProfileImageUrl(profileImageUrl: String) {
        UserData.setValue(profileImageUrl, forKey: .profileImageUrl)
    }
}
