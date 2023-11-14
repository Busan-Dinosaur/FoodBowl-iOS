//
//  BaseViewType.swift
//  FoodBowl
//
//  Created by COBY_PRO on 10/20/23.
//

import UIKit

protocol BaseViewType: UIView {
    func setupLayout()
    func configureUI()
}

extension BaseViewType {
    /// 기본적인 메서드를 한 번에 호출하는 메서드
    func baseInit() {
        self.setupLayout()
        self.configureUI()
    }
}
