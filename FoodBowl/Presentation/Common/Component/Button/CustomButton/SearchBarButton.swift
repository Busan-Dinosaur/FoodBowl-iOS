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
        $0.image = ImageLiteral.search.resize(to: CGSize(width: 20, height: 20)).withRenderingMode(.alwaysTemplate)
        $0.tintColor = .subTextColor
    }

    let placeholderLabel = UILabel().then {
        $0.font = UIFont.preferredFont(forTextStyle: .callout, weight: .regular)
        $0.textColor = .grey001
        $0.text = "가게 검색"
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
        backgroundColor = .mainBackgroundColor
        layer.cornerRadius = 20
        layer.borderWidth = 1
        layer.borderColor = UIColor.grey002.cgColor
    }
}
