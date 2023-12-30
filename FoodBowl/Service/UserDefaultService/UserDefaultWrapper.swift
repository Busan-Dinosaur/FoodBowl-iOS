//
//  UserDefaultWrapper.swift
//  FoodBowl
//
//  Created by COBY_PRO on 2023/09/16.
//

import Foundation

@propertyWrapper
struct UserDefaultWrapper<T: Codable> {
    
    private let key: String
    private let defaultValue: T?

    init(key: String, defaultValue: T?) {
        self.key = key
        self.defaultValue = defaultValue
    }

    var wrappedValue: T? {
        get {
            if let savedData = UserDefaults.standard.object(forKey: key) as? Data {
                let decoder = JSONDecoder()
                if let lodedObejct = try? decoder.decode(T.self, from: savedData) {
                    return lodedObejct
                }
            }
            return defaultValue
        }
        set {
            let encoder = JSONEncoder()
            if let encoded = try? encoder.encode(newValue) {
                UserDefaults.standard.setValue(encoded, forKey: key)
            }
        }
    }
}

enum UserDefaultsManager {
    @UserDefaultWrapper(key: "currentUser", defaultValue: nil)
    static var currentUser: MemberProfileDTO?

    @UserDefaultWrapper(key: "currentUniv", defaultValue: nil)
    static var currentUniv: SchoolItemDTO?
}
