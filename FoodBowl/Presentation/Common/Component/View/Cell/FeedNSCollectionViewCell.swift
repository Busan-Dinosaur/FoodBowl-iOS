//
//  FeedNSCollectionViewCell.swift
//  FoodBowl
//
//  Created by COBY_PRO on 2023/07/22.
//

import UIKit

import SnapKit
import Then

final class FeedNSCollectionViewCell: BaseCollectionViewCell {
    var userButtonTapAction: ((FeedNSCollectionViewCell) -> Void)?
    var optionButtonTapAction: ((FeedNSCollectionViewCell) -> Void)?

    // MARK: - property
    let userInfoView = UserInfoView()

    lazy var commentLabel = UILabel().then {
        $0.font = UIFont.preferredFont(forTextStyle: .subheadline, weight: .light)
        $0.textColor = .mainTextColor
        $0.numberOfLines = 0
        $0.text = "맛있어요 정말로"
    }

    let photoListView = PhotoListView()

    override func setupLayout() {
        contentView.addSubviews(userInfoView, commentLabel, photoListView)

        userInfoView.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview()
            $0.height.equalTo(64)
        }

        commentLabel.snp.makeConstraints {
            $0.top.equalTo(userInfoView.snp.bottom)
            $0.leading.trailing.equalToSuperview().inset(SizeLiteral.horizantalPadding)
            $0.bottom.equalTo(photoListView.snp.top).offset(-10)
        }

        photoListView.snp.makeConstraints {
            $0.top.equalTo(commentLabel.snp.bottom)
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalToSuperview().inset(14)
            $0.height.equalTo(100)
        }
    }

    override func configureUI() {
        userInfoView.userImageButton.addAction(UIAction { _ in self.userButtonTapAction?(self) }, for: .touchUpInside)
        userInfoView.userNameButton.addAction(UIAction { _ in self.userButtonTapAction?(self) }, for: .touchUpInside)
        userInfoView.optionButton.addAction(UIAction { _ in self.optionButtonTapAction?(self) }, for: .touchUpInside)
    }

    override func preferredLayoutAttributesFitting(_ layoutAttributes: UICollectionViewLayoutAttributes)
        -> UICollectionViewLayoutAttributes {
        super.preferredLayoutAttributesFitting(layoutAttributes)

        let targetSize = CGSize(width: layoutAttributes.frame.width, height: 0)

        layoutAttributes.frame.size = contentView.systemLayoutSizeFitting(
            targetSize,
            withHorizontalFittingPriority: .required,
            verticalFittingPriority: .fittingSizeLevel
        )
        print(layoutAttributes)
        return layoutAttributes
    }

    override func prepareForReuse() {
        super.prepareForReuse()
    }

    func setupData(_ review: ReviewContent) {
        commentLabel.text = review.content
        if review.imagePaths.isEmpty {
            removePhotoList()
        } else {
            photoListView.photos = review.imagePaths
            createPhotoList()
        }
    }

    func createPhotoList() {
        photoListView.isHidden = false

        photoListView.snp.remakeConstraints {
            $0.top.equalTo(commentLabel.snp.bottom)
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalToSuperview().inset(14)
            $0.height.equalTo(100)
        }
    }

    func removePhotoList() {
        photoListView.isHidden = true

        photoListView.snp.remakeConstraints {
            $0.top.equalTo(commentLabel.snp.bottom)
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalToSuperview().inset(14)
            $0.height.equalTo(0)
        }
    }
}
