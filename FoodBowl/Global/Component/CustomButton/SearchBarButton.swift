//
//  SearchBarButton.swift
//  FoodBowl
//
//  Created by Coby Kim on 2023/01/13.
//

import UIKit

import SnapKit
import Then

final class SearchBarButton: UIButton {
    // MARK: - property
    private let searchIconView = UIImageView().then {
        $0.image = ImageLiteral.search.withConfiguration(UIImage.SymbolConfiguration(scale: .medium))
        $0.tintColor = .subText
    }

    let placeholderLabel = UILabel().then {
        $0.font = UIFont.preferredFont(forTextStyle: .callout, weight: .regular)
        $0.textColor = .grey001
        $0.text = "새로운 맛집과 유저를 찾아보세요."
    }

    // MARK: - init
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupLayout()
        configureUI()
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - life cycle
    private func setupLayout() {
        addSubviews(searchIconView, placeholderLabel)

        searchIconView.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalToSuperview().inset(14)
        }

        placeholderLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalTo(searchIconView.snp.trailing).offset(10)
        }
    }

    private func configureUI() {
        backgroundColor = .mainBackground
        layer.cornerRadius = 20
        layer.borderWidth = 1
        layer.borderColor = UIColor.grey002.cgColor
    }
}
