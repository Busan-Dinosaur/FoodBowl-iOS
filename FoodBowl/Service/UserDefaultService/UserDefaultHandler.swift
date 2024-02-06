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
    
    static func setSchoolId(schoolId: Int) {
        UserData.setValue(schoolId, forKey: .schoolId)
    }
    
    static func setSchoolName(schoolName: String) {
        UserData.setValue(schoolName, forKey: .schoolName)
    }
    
    static func setSchoolX(schoolX: Double) {
        UserData.setValue(schoolX, forKey: .schoolX)
    }
    
    static func setSchoolY(schoolY: Double) {
        UserData.setValue(schoolY, forKey: .schoolY)
    }
}
