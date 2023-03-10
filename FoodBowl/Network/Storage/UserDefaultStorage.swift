//
//  UserDefaultStorage.swift
//  FoodBowl
//
//  Created by COBY_PRO on 2023/02/01.
//

import Foundation

enum DataKeys: String, CaseIterable {
    case isLogin
    case userID
    case accessToken
    case refreshToken
    case nickname
}

enum UserDefaultStorage {
    static var isLogin: Bool {
        return UserData<Bool>.getValue(forKey: .isLogin) ?? false
    }

    static var userID: String {
        return UserData<String>.getValue(forKey: .userID) ?? ""
    }

    static var accessToken: String {
        return UserData<String>.getValue(forKey: .accessToken) ?? ""
    }

    static var refreshToken: String {
        return UserData<String>.getValue(forKey: .refreshToken) ?? ""
    }

    static var nickname: String? {
        return UserData<String?>.getValue(forKey: .nickname) ?? nil
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
