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
    let borderLineView = UIView().then {
        $0.backgroundColor = .grey003
    }

    var collectionViewFlowLayout: UICollectionViewFlowLayout = .init()

    lazy var listCollectionView: UICollectionView = .init()

    // MARK: - init
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupProperty()
        setupLayout()
        configureUI()
        setupRefreshControl()
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setupProperty() {}

    func setupLayout() {
        addSubviews(borderLineView, listCollectionView)

        borderLineView.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.leading.trailing.equalToSuperview().inset(BaseSize.horizantalPadding)
            $0.height.equalTo(1)
        }

        listCollectionView.snp.makeConstraints {
            $0.top.equalTo(borderLineView.snp.bottom)
            $0.leading.trailing.bottom.equalToSuperview()
        }
    }

    func configureUI() {
        backgroundColor = .mainBackground
    }

    func setupRefreshControl() {}
}
