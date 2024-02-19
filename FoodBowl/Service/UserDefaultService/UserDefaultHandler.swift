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
    
    static func setInAppReviewCount(inAppReviewCount: Int) {
        UserData.setValue(inAppReviewCount, forKey: .inAppReviewCount)
    }
    
    static func setIsLogin(isLogin: Bool) {
        UserData.setValue(isLogin, forKey: .isLogin)
    }
    
    static func setTokenExpiryDate(tokenExpiryDate: Date) {
        UserData.setValue(tokenExpiryDate, forKey: .tokenExpiryDate)
    }
    
    static func setId(id: Int) {
        UserData.setValue(id, forKey: .id)
    }
    
    static func setNickname(nickname: String) {
        UserData.setValue(nickname, forKey: .nickname)
    }
    
    static func setIntroduction(introduction: String) {
        UserData.setValue(introduction, forKey: .introduction)
    }
    
    static func setProfileImageUrl(profileImageUrl: String) {
        UserData.setValue(profileImageUrl, forKey: .profileImageUrl)
    }
    
    static func setPlaceId(placeId: Int) {
        UserData.setValue(placeId, forKey: .placeId)
    }
    
    static func setPlaceName(placeName: String) {
        UserData.setValue(placeName, forKey: .placeName)
    }
    
    static func setPlaceX(placeX: Double) {
        UserData.setValue(placeX, forKey: .placeX)
    }
    
    static func setPlaceY(placeY: Double) {
        UserData.setValue(placeY, forKey: .placeY)
    }
}
