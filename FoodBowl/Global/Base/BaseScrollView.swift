//
//  BaseScrollView.swift
//  FoodBowl
//
//  Created by COBY_PRO on 2022/12/25.
//

import UIKit

class BaseScrollView<Model>: UIScrollView {
    var model: Model? {
        didSet {
            if let model = model {
                bind(model)
            }
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)

        configUI()
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configUI() {}
    func bind(_: Model) {}
}
