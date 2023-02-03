//
//  EmptyFeedView.swift
//  FoodBowl
//
//  Created by COBY_PRO on 2022/12/23.
//

import UIKit

import SnapKit
import Then

final class EmptyFeedView: UIView {
    // MARK: - property

    private let emptyImage = UIImageView(image: ImageLiteral.btnProfile)

    private let emptyLabel = UILabel().then {
        $0.font = UIFont.preferredFont(forTextStyle: .title2, weight: .bold)
        $0.textColor = .mainPink
        $0.textAlignment = .center
        $0.text = "피드가 없습니다."
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
        addSubviews(emptyImage, emptyLabel)

        emptyImage.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.centerY.equalToSuperview().offset(-100)
            $0.width.height.equalTo(80)
        }

        emptyLabel.snp.makeConstraints {
            $0.top.equalTo(emptyImage.snp.bottom).offset(20)
            $0.centerX.equalToSuperview()
        }
    }
}
