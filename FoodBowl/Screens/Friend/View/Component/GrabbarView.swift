//
//  GrabbarView.swift
//  FoodBowl
//
//  Created by COBY_PRO on 2023/07/25.
//

import UIKit

import SnapKit
import Then

final class GrabbarView: UIView {

    // MARK: - init
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupLayout()
        configureUI()
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setupLayout() {}

    func configureUI() {
        backgroundColor = .mainPink
    }
}
