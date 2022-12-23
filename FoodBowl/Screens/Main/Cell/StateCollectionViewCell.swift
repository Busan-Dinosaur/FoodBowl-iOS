//
//  StateCollectionViewCell.swift
//  FoodBowl
//
//  Created by COBY_PRO on 2022/12/23.
//

import UIKit

import SnapKit
import Then

final class StateCollectionViewCell: BaseCollectionViewCell {
    // MARK: - property

    let stateLabel = UILabel().then {
        $0.font = UIFont.preferredFont(forTextStyle: .body, weight: .semibold)
        $0.textAlignment = .center
    }

    override func render() {
        addSubview(stateLabel)

        stateLabel.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
    }

    override func configUI() {
        backgroundColor = .mainBlack.withAlphaComponent(0.15)
        stateLabel.textColor = .black
        layer.masksToBounds = true
        layer.cornerRadius = 8
    }

    override var isSelected: Bool {
        willSet {
            setSelected(newValue)
        }
    }

    private func setSelected(_ selected: Bool) {
        if selected {
            backgroundColor = .mainBlack
            stateLabel.textColor = .white
        } else {
            backgroundColor = .mainBlack.withAlphaComponent(0.15)
            stateLabel.textColor = .black
        }
    }
}
