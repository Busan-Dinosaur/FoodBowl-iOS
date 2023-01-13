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
        $0.image = ImageLiteral.btnSearch.withConfiguration(UIImage.SymbolConfiguration(scale: .large))
        $0.tintColor = .subText
    }
    
    let label = UILabel().then {
        let label = UILabel()
        $0.font = UIFont.preferredFont(forTextStyle: .body, weight: .medium)
        $0.textColor = .grey001
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
        addSubviews(searchIconView, label)
        
        searchIconView.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalToSuperview().inset(20)
        }

        label.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalTo(searchIconView.snp.trailing).offset(10)
        }
    }

    private func configUI() {
        backgroundColor = .white
        makeBorderLayer(color: .grey002)
    }
}
