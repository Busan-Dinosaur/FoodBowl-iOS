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
    var followButtonTapAction: ((FeedCollectionViewCell) -> Void)?
    var mapButtonTapAction: ((FeedCollectionViewCell) -> Void)?
    var storeButtonTapAction: ((FeedCollectionViewCell) -> Void)?
    var bookmarkButtonTapAction: ((FeedCollectionViewCell) -> Void)?
    var commentButtonTapAction: ((FeedCollectionViewCell) -> Void)?
    var optionButtonTapAction: ((FeedCollectionViewCell) -> Void)?
    var commentLabelTapAction: ((FeedCollectionViewCell) -> Void)?

    var collapsed = true {
        didSet {
            commentLabel.numberOfLines = collapsed ? 2 : 0
            commentLabel.invalidateIntrinsicContentSize()
            commentLabel.setNeedsLayout()
            commentLabel.setNeedsDisplay()
            commentLabel.layoutIfNeeded()
        }
    }

    var images: [String] = ["image1", "image2", "image3"]

    // MARK: - property

    let userInfoView = UserInfoView()

    let storeInfoView = StoreInfoView()

    lazy var feedImageView = HorizontalScrollView(
        horizontalWidth: UIScreen.main.bounds.size.width,
        horizontalHeight: UIScreen.main.bounds.size.width
    )

    lazy var commentLabel = UILabel().then {
        $0.font = UIFont.preferredFont(forTextStyle: .subheadline, weight: .light)
        $0.textColor = .mainText
        $0.numberOfLines = 2
        $0.isUserInteractionEnabled = true
    }

    let bookmarkButton = UIButton().then {
        $0.setImage(
            ImageLiteral.btnBookmark.resize(to: CGSize(width: 20, height: 20)).withRenderingMode(.alwaysTemplate),
            for: .normal
        )
        $0.tintColor = .mainText
        $0.setTitle("4", for: .normal)
        $0.setTitleColor(.subText, for: .normal)
        $0.titleLabel?.font = .preferredFont(forTextStyle: .footnote, weight: .regular)
        $0.semanticContentAttribute = .forceLeftToRight
        $0.marginImagewithText(margin: 10.0)
    }

    let commentButton = UIButton().then {
        $0.setImage(
            ImageLiteral.btnChat.resize(to: CGSize(width: 20, height: 20)).withRenderingMode(.alwaysTemplate),
            for: .normal
        )
        $0.tintColor = .mainText
        $0.setTitle("51", for: .normal)
        $0.setTitleColor(.subText, for: .normal)
        $0.titleLabel?.font = .preferredFont(forTextStyle: .footnote, weight: .regular)
        $0.semanticContentAttribute = .forceLeftToRight
        $0.marginImagewithText(margin: 10.0)
    }

    private let stackView = UIStackView().then {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.axis = .horizontal
        $0.alignment = .center
        $0.distribution = .equalSpacing
    }

    let optionButton = MoreButton()

    let dateLabel = UILabel().then {
        $0.font = UIFont.preferredFont(forTextStyle: .caption1, weight: .regular)
        $0.textColor = .subText
        $0.text = "10일 전"
    }

    override func render() {
        contentView.addSubviews(userInfoView, feedImageView, storeInfoView, commentLabel, stackView, optionButton, dateLabel)

        [bookmarkButton, commentButton].forEach {
            stackView.addArrangedSubview($0)
        }

        userInfoView.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview()
            $0.height.equalTo(60)
        }

        feedImageView.snp.makeConstraints {
            $0.top.equalTo(userInfoView.snp.bottom)
            $0.width.height.equalTo(UIScreen.main.bounds.size.width)
        }

        storeInfoView.snp.makeConstraints {
            $0.top.equalTo(feedImageView.snp.bottom)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(60)
        }

        commentLabel.snp.makeConstraints {
            $0.top.equalTo(storeInfoView.snp.bottom)
            $0.leading.trailing.equalToSuperview().inset(20)
        }

        stackView.snp.makeConstraints {
            $0.top.equalTo(commentLabel.snp.bottom).offset(12)
            $0.leading.equalToSuperview().inset(20)
            $0.width.equalTo(120)
        }

        optionButton.snp.makeConstraints {
            $0.top.equalTo(commentLabel.snp.bottom).offset(12)
            $0.trailing.equalToSuperview().inset(20)
        }

        dateLabel.snp.makeConstraints {
            $0.top.equalTo(stackView.snp.bottom).offset(14)
            $0.leading.bottom.equalToSuperview().inset(20)
        }
    }

    override func configUI() {
        feedImageView.model = [ImageLiteral.food1, ImageLiteral.food2, ImageLiteral.food3]

        userInfoView.userImageButton.addAction(UIAction { _ in self.userButtonTapAction?(self) }, for: .touchUpInside)
        userInfoView.userNameButton.addAction(UIAction { _ in self.userButtonTapAction?(self) }, for: .touchUpInside)
        userInfoView.followButton.addAction(UIAction { _ in self.followButtonTapAction?(self) }, for: .touchUpInside)
        storeInfoView.mapButton.addAction(UIAction { _ in self.mapButtonTapAction?(self) }, for: .touchUpInside)
        storeInfoView.storeNameButton.addAction(UIAction { _ in self.storeButtonTapAction?(self) }, for: .touchUpInside)
        bookmarkButton.addAction(UIAction { _ in self.bookmarkButtonTapAction?(self) }, for: .touchUpInside)
        commentButton.addAction(UIAction { _ in self.commentButtonTapAction?(self) }, for: .touchUpInside)
        optionButton.addAction(UIAction { _ in self.optionButtonTapAction?(self) }, for: .touchUpInside)

        let tap = UITapGestureRecognizer(target: self, action: #selector(invalidate))
        commentLabel.addGestureRecognizer(tap)
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

    @objc
    private func invalidate(_: Any) {
        commentLabelTapAction?(self)
    }
}
