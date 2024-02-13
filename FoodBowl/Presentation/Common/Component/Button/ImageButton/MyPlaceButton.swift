//
//  MyPlaceButton.swift
//  FoodBowl
//
//  Created by Coby on 2/14/24.
//

import UIKit

final class MyPlaceButton: UIButton {
    
    override var isSelected: Bool {
        didSet {
            if isSelected {
                setImage(
                    ImageLiteral.placeFill.resize(to: CGSize(width: 20, height: 20)).withRenderingMode(.alwaysTemplate),
                    for: .normal
                )
                tintColor = .mainBackgroundColor
                backgroundColor = .mainPink
            } else {
                setImage(
                    ImageLiteral.place.resize(to: CGSize(width: 20, height: 20)).withRenderingMode(.alwaysTemplate),
                    for: .normal
                )
                tintColor = .mainPink
                backgroundColor = .mainBackgroundColor
            }
        }
    }

    // MARK: - init
    
    override init(frame _: CGRect) {
        super.init(frame: .init(origin: .zero, size: .init(width: 30, height: 30)))
        self.configureUI()
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func configureUI() {
        self.setImage(ImageLiteral.place.resize(to: CGSize(width: 20, height: 20)).withRenderingMode(.alwaysTemplate), for: .normal)
        self.tintColor = .mainPink
        self.backgroundColor = .mainBackgroundColor
    }
}
