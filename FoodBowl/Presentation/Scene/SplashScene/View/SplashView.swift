//
//  SplashView.swift
//  FoodBowl
//
//  Created by Coby on 2/1/24.
//

import Combine
import UIKit

import SnapKit
import Then

final class SplashView: UIView, BaseViewType {
    
    // MARK: - ui component
    
    private let titleLabel = UILabel().then {
        $0.font = .font(.regular, ofSize: 50)
        $0.textColor = .white
        $0.text = "FoodBowl"
    }
    private let subTitleLabel = UILabel().then {
        $0.font = .font(.regular, ofSize: 30)
        $0.textColor = .white
        $0.text = "Just Do Eat"
    }
    
    // MARK: - init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.baseInit()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - base func
    
    func setupLayout() {
        self.addSubviews(
            self.titleLabel,
            self.subTitleLabel
        )

        self.titleLabel.snp.makeConstraints {
            $0.top.equalTo(self.safeAreaLayoutGuide.snp.top).inset(100)
            $0.centerX.equalToSuperview()
        }

        self.subTitleLabel.snp.makeConstraints {
            $0.top.equalTo(self.titleLabel.snp.bottom).offset(40)
            $0.centerX.equalToSuperview()
        }
    }
    
    func configureUI() {
        self.backgroundColor = .mainPink
    }
}
