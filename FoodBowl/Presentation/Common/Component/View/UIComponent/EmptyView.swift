//
//  EmptyView.swift
//  FoodBowl
//
//  Created by Coby on 2/4/24.
//

import UIKit

import SnapKit
import Then

final class EmptyView: UIView, BaseViewType {

    private let emptyLabel = UILabel().then {
        $0.font = UIFont.preferredFont(forTextStyle: .body, weight: .regular)
        $0.textColor = .subTextColor
    }

    // MARK: - init
    
    init(message: String) {
        super.init(frame: .zero)
        self.baseInit()
        self.emptyLabel.text = message
    }
    
    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setupLayout() {
        self.addSubviews(emptyLabel)
        
        self.emptyLabel.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
    }

    func configureUI() {
        self.backgroundColor = .mainBackgroundColor
    }
}
