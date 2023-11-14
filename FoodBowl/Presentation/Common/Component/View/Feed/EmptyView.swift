//
//  EmptyView.swift
//  FoodBowl
//
//  Created by COBY_PRO on 2022/12/23.
//

import UIKit

import SnapKit
import Then

final class EmptyView: UIView {
    // MARK: - property
    
    private let emptyLabel = UILabel().then {
        $0.font = UIFont.preferredFont(forTextStyle: .callout)
        $0.textColor = .subTextColor
        $0.textAlignment = .center
        $0.text = "검색 결과가 없습니다."
    }

    // MARK: - init
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupLayout()
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupLayout() {
        addSubviews(emptyLabel)

        emptyLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.centerY.equalToSuperview().offset(-100)
        }
    }
}
