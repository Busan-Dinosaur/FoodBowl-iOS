//
//  Logger.swift
//  FoodBowl
//
//  Created by COBY_PRO on 2022/12/23.
//

import Foundation

class Logger {
    static func debugDescription<T>(_ object: T?, filename: String = #file, line: Int = #line, funcName: String = #function) {
        #if DEBUG
            if let obj = object {
                print("\(Date()) \(filename.components(separatedBy: "/").last ?? "")(\(line)) : \(funcName) : \(obj)")
            } else {
                print("\(Date()) \(filename.components(separatedBy: "/").last ?? "")(\(line)) : \(funcName) : nil")
            }
        #endif
    }
}
