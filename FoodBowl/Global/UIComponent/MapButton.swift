//
//  MapButton.swift
//  FoodBowl
//
//  Created by COBY_PRO on 2023/01/20.
//

import UIKit

final class MapButton: UIButton {
    // MARK: - init

    override init(frame _: CGRect) {
        super.init(frame: .init(origin: .zero, size: .init(width: 30, height: 30)))
        configUI()
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - life cycle

    private func configUI() {
        setImage(ImageLiteral.btnMaps.resize(to: CGSize(width: 30, height: 30)), for: .normal)
        tintColor = .black
    }
}
