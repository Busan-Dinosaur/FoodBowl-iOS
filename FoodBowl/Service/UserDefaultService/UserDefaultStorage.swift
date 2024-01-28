//
//  UserDefaultStorage.swift
//  FoodBowl
//
//  Created by COBY_PRO on 2023/02/01.
//

import Foundation

enum DataKeys: String, CaseIterable {
    case tokenExpiryDate
    case isLogin
    case id
    case nickname
    case introduction
    case profileImageUrl
    case schoolId
    case schoolName
    case schoolX
    case schoolY
}

enum UserDefaultStorage {
    static var tokenExpiryDate: Date {
        return UserData<Date>.getValue(forKey: .tokenExpiryDate) ?? .now
    }
    
    static var isLogin: Bool {
        return UserData<Bool>.getValue(forKey: .isLogin) ?? false
    }
    
    static var id: Int {
        return UserData<Int>.getValue(forKey: .id) ?? 0
    }
    
    static var nickname: String {
        return UserData<String>.getValue(forKey: .nickname) ?? ""
    }
    
    static var introduction: String? {
        return UserData<String>.getValue(forKey: .introduction)
    }
    
    static var profileImageUrl: String? {
        return UserData<String>.getValue(forKey: .profileImageUrl)
    }
    
    static var schoolId: Int? {
        return UserData<Int>.getValue(forKey: .schoolId)
    }
    
    static var schoolName: String? {
        return UserData<String>.getValue(forKey: .schoolName)
    }
    
    static var schoolX: Double? {
        return UserData<Double>.getValue(forKey: .schoolX)
    }
    
    static var schoolY: Double? {
        return UserData<Double>.getValue(forKey: .schoolY)
    }
}

enum UserData<T> {
    static func getValue(forKey key: DataKeys) -> T? {
        if let data = UserDefaults.standard.value(forKey: key.rawValue) as? T {
            return data
        } else {
            return nil
        }
    }

    static func setValue(_ value: T, forKey key: DataKeys) {
        UserDefaults.standard.set(value, forKey: key.rawValue)
    }

    static func clearAll() {
        DataKeys.allCases.forEach { key in
            UserDefaults.standard.removeObject(forKey: key.rawValue)
        }
    }

    static func clear(forKey key: DataKeys) {
        UserDefaults.standard.removeObject(forKey: key.rawValue)
    }
}
