//
//  ModalView.swift
//  FoodBowl
//
//  Created by COBY_PRO on 2023/07/27.
//

import UIKit

import SnapKit
import Then

class ModalView: UIView {
    // MARK: - property
    var collectionViewFlowLayout: UICollectionViewFlowLayout = .init()

    lazy var listCollectionView: UICollectionView = .init()

    let resultLabel = UILabel().then {
        $0.font = UIFont.preferredFont(forTextStyle: .subheadline, weight: .regular)
        $0.textColor = .subText
        $0.textAlignment = .center
    }

    // MARK: - init
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupProperty()
        setupLayout()
        configureUI()
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setupProperty() {}

    func setupLayout() {
        addSubviews(listCollectionView, resultLabel)

        listCollectionView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }

        resultLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(4)
            $0.leading.trailing.equalToSuperview()
        }
    }

    func configureUI() {
        resultLabel.isHidden = true
        backgroundColor = .mainBackground
    }

    func showContent() {}

    func showResult() {}
}
