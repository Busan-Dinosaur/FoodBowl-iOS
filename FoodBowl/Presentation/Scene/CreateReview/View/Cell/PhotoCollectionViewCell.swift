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

final class PhotoCollectionViewCell: BaseCollectionViewCell {
    // MARK: - property
    lazy var foodImageView = UIImageView().then {
        $0.backgroundColor = .grey002
        $0.contentMode = .scaleAspectFill
    }

    override func setupLayout() {
        contentView.addSubviews(foodImageView)

        foodImageView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }

    override func configureUI() {
        backgroundColor = .grey002
        clipsToBounds = true
        makeBorderLayer(color: .grey002)
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        foodImageView.image = nil
    }

    func configureCell(_ imageURL: URL) {
        foodImageView.kf.setImage(with: imageURL)
        foodImageView.isUserInteractionEnabled = true

        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(imageTapped))
        foodImageView.addGestureRecognizer(tapGesture)
    }

    @objc
    func imageTapped() {
        let imageViewController = ImageViewController()
        imageViewController.imageScrollView.imageView.image = foodImageView.image
        imageViewController.modalPresentationStyle = .fullScreen
        imageViewController.modalTransitionStyle = .crossDissolve

        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now()) {
            guard let rootVC = (UIApplication.shared.connectedScenes.first as? UIWindowScene)?.windows.first?.rootViewController
            else { return }
            rootVC.present(imageViewController, animated: true)
        }
    }
}
