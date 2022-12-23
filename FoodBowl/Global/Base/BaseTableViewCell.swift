//
//  BaseTableViewCell.swift
//  FoodBowl
//
//  Created by COBY_PRO on 2022/12/23.
//

import UIKit

class BaseTableViewCell: UITableViewCell {
    // MARK: - init

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        render()
        configUI()
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - func

    func render() {
        // Override Layout
    }

    func configUI() {
        // Override ConfigUI
    }
}
