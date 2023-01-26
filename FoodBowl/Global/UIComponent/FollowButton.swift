//
//  FollowButton.swift
//  FoodBowl
//
//  Created by COBY_PRO on 2023/01/09.
//

import UIKit

import SnapKit
import Then

final class FollowButton: UIButton {
    override var isSelected: Bool {
        didSet {
            if isSelected {
                backgroundColor = .grey002
                label.text = "팔로잉"
            } else {
                backgroundColor = .mainPink
                label.text = "팔로우"
            }
        }
    }

    // MARK: - property

    let label = UILabel().then {
        let label = UILabel()
        $0.textColor = .white
        $0.font = UIFont.preferredFont(forTextStyle: .footnote, weight: .medium)
        $0.text = "팔로우"
    }

    // MARK: - init

    override init(frame: CGRect) {
        super.init(frame: frame)
        render()
        configUI()
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - life cycle

    private func render() {
        addSubview(label)

        label.snp.makeConstraints {
            $0.centerX.centerY.equalToSuperview()
        }
    }

    private func configUI() {
        backgroundColor = .mainPink
        layer.cornerRadius = 15
        layer.masksToBounds = false
    }
}
