//
//  SetCategoryViewController.swift
//  FoodBowl
//
//  Created by COBY_PRO on 2023/01/10.
//

import UIKit

import SnapKit
import Then

final class SetCategoryViewController: BaseViewController {
    // MARK: - property

    private let screenText = UILabel().then {
        $0.textColor = .red
        $0.text = "SetCategory"
    }

    // MARK: - life cycle

    override func render() {
        view.addSubview(screenText)
        screenText.snp.makeConstraints {
            $0.centerX.centerY.equalToSuperview()
        }
    }
}
