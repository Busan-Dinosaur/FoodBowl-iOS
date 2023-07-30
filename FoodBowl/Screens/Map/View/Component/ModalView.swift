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
        addSubviews(listCollectionView)

        listCollectionView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }

    func configureUI() {
        backgroundColor = .mainBackground
    }
}
