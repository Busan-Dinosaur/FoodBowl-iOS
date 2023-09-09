//
//  ViewModelType.swift
//  FoodBowl
//
//  Created by COBY_PRO on 2023/09/09.
//

protocol ViewModelType {
    associatedtype Input
    associatedtype Output

    func transform(from input: Input) -> Output
}
