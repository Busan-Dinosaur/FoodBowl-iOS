//
//  ReviewToggleButton.swift
//  FoodBowl
//
//  Created by COBY_PRO on 2023/09/15.
//

import UIKit

import SnapKit
import Then

final class ReviewToggleButton: UIButton, BaseViewType {
    
    override var isSelected: Bool {
        didSet {
            if isSelected {
                label.text = "모두"
            } else {
                label.text = "친구만"
            }
        }
    }

    // MARK: - ui component
    
    private let label = UILabel().then {
        let label = UILabel()
        $0.font = UIFont.preferredFont(forTextStyle: .subheadline, weight: .medium)
        $0.textColor = .subTextColor
    }

    // MARK: - init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.baseInit()
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setupLayout() {
        self.addSubviews(self.label)

        self.snp.makeConstraints {
            $0.width.equalTo(80)
            $0.height.equalTo(30)
        }

        self.label.snp.makeConstraints {
            $0.centerX.centerY.equalToSuperview()
        }
    }

    func configureUI() {
        self.layer.cornerRadius = 4
        self.layer.borderColor = UIColor.grey002.cgColor
        self.layer.borderWidth = 1
    }
}
