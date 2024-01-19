//
//  PhotoCollectionViewCell.swift
//  FoodBowl
//
//  Created by COBY_PRO on 2022/12/23.
//

import UIKit

import Kingfisher
import SnapKit
import Then

final class PhotoCollectionViewCell: UICollectionViewCell, BaseViewType {
    
    // MARK: - ui component
    
    lazy var imageView = UIImageView().then {
        $0.backgroundColor = .grey002
        $0.contentMode = .scaleAspectFill
    }
    
    // MARK: - property
    
    var cellAction: ((PhotoCollectionViewCell) -> Void)?
    
    // MARK: - init

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.baseInit()
        self.setupAction()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setupLayout() {
        self.contentView.addSubviews(self.imageView)

        self.imageView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    func configureUI() {
        self.backgroundColor = .grey002
        self.clipsToBounds = true
        self.makeBorderLayer(color: .grey002)
    }
    
    private func setupAction() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(cellTapped))
        contentView.addGestureRecognizer(tapGesture)
    }
    
    @objc
    private func cellTapped() {
        self.cellAction?(self)
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        self.imageView.image = nil
    }
}

// MARK: - Public - func
extension PhotoCollectionViewCell {
    func configureCell(_ url: String) {
        self.imageView.kf.setImage(with: URL(string: url))
        self.imageView.isUserInteractionEnabled = true
    }
}
