//
//  FeedCollectionViewCell.swift
//  FoodBowl
//
//  Created by COBY_PRO on 2022/12/23.
//

import UIKit

import SnapKit
import Then

final class FeedCollectionViewCell: BaseCollectionViewCell {
    var userButtonTapAction: ((FeedCollectionViewCell) -> Void)?
    var optionButtonTapAction: ((FeedCollectionViewCell) -> Void)?
    var storeButtonTapAction: ((FeedCollectionViewCell) -> Void)?
    var bookmarkButtonTapAction: ((FeedCollectionViewCell) -> Void)?

    // MARK: - property
    let userInfoView = UserInfoView()

    lazy var commentLabel = UILabel().then {
        $0.font = UIFont.preferredFont(forTextStyle: .subheadline, weight: .light)
        $0.textColor = .mainTextColor
        $0.numberOfLines = 0
        $0.text = "맛있어요 정말로"
    }

    let photoListView = PhotoListView()

    let storeInfoView = StoreInfoView()

    override func setupLayout() {
        contentView.addSubviews(userInfoView, commentLabel, photoListView, storeInfoView)

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
            $0.height.equalTo(100)
        }

        storeInfoView.snp.makeConstraints {
            $0.top.equalTo(photoListView.snp.bottom).offset(10)
            $0.leading.trailing.equalToSuperview().inset(SizeLiteral.horizantalPadding)
            $0.bottom.equalToSuperview().inset(14)
            $0.height.equalTo(54)
        }
    }

    override func configureUI() {
        setupAction()
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
        return layoutAttributes
    }

    private func setupAction() {
        userInfoView.userImageButton.addAction(UIAction { _ in self.userButtonTapAction?(self) }, for: .touchUpInside)
        userInfoView.userNameButton.addAction(UIAction { _ in self.userButtonTapAction?(self) }, for: .touchUpInside)
        userInfoView.optionButton.addAction(UIAction { _ in self.optionButtonTapAction?(self) }, for: .touchUpInside)
        storeInfoView.storeNameButton.addAction(UIAction { _ in self.storeButtonTapAction?(self) }, for: .touchUpInside)
        storeInfoView.bookmarkButton.addAction(UIAction { _ in self.bookmarkButtonTapAction?(self) }, for: .touchUpInside)
    }

    override func prepareForReuse() {
        super.prepareForReuse()
    }

    func setupData(_ review: Review) {
        let member = review.writer
        let store = review.store
        let review = review.review

        userInfoView.setupData(member)
        storeInfoView.setupData(store)

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

        storeInfoView.snp.remakeConstraints {
            $0.top.equalTo(photoListView.snp.bottom).offset(10)
            $0.leading.trailing.equalToSuperview().inset(SizeLiteral.horizantalPadding)
            $0.bottom.equalToSuperview().inset(14)
            $0.height.equalTo(54)
        }
    }

    func removePhotoList() {
        photoListView.isHidden = true

        storeInfoView.snp.remakeConstraints {
            $0.top.equalTo(commentLabel.snp.bottom).offset(10)
            $0.leading.trailing.equalToSuperview().inset(SizeLiteral.horizantalPadding)
            $0.bottom.equalToSuperview().inset(14)
            $0.height.equalTo(54)
        }
    }
}
