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

    lazy var feedImageView = HorizontalScrollView(horizontalWidth: UIScreen.main.bounds.size.width, horizontalHeight: UIScreen.main.bounds.size.width)

    lazy var commentLabel = UILabel().then {
        $0.font = UIFont.preferredFont(forTextStyle: .subheadline, weight: .light)
        $0.numberOfLines = 2
        let tap = UITapGestureRecognizer(target: self, action: #selector(invalidate))
        $0.isUserInteractionEnabled = true
        $0.addGestureRecognizer(tap)
    }

    let bookmarkButton = UIButton().then {
        $0.setImage(ImageLiteral.btnBookmark.resize(to: CGSize(width: 20, height: 20)), for: .normal)
        $0.setTitle("  4", for: .normal)
        $0.setTitleColor(.subText, for: .normal)
        $0.titleLabel?.font = .preferredFont(forTextStyle: .footnote, weight: .regular)
        $0.semanticContentAttribute = .forceLeftToRight
    }

    let chatButton = UIButton().then {
        $0.setImage(ImageLiteral.btnChat.resize(to: CGSize(width: 20, height: 20)), for: .normal)
        $0.setTitle("  51", for: .normal)
        $0.setTitleColor(.subText, for: .normal)
        $0.titleLabel?.font = .preferredFont(forTextStyle: .footnote, weight: .regular)
        $0.semanticContentAttribute = .forceLeftToRight
    }

    private let stackView = UIStackView().then {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.axis = .horizontal
        $0.alignment = .center
        $0.distribution = .equalSpacing
    }

    let optionButton = OptionButton()

    override func render() {
        contentView.addSubviews(userInfoView, feedImageView, storeInfoView, commentLabel, stackView, optionButton)

        [bookmarkButton, chatButton].forEach {
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
            $0.top.equalTo(commentLabel.snp.bottom).offset(14)
            $0.bottom.equalToSuperview().inset(10)
            $0.leading.equalToSuperview().inset(20)
            $0.width.equalTo(120)
        }

        optionButton.snp.makeConstraints {
            $0.top.equalTo(commentLabel.snp.bottom).offset(14)
            $0.bottom.equalToSuperview().inset(10)
            $0.trailing.equalToSuperview().inset(20)
        }
    }

    override func configUI() {
        super.configUI()
        feedImageView.model = [ImageLiteral.food1, ImageLiteral.food2, ImageLiteral.food3]
    }

    override func preferredLayoutAttributesFitting(_ layoutAttributes: UICollectionViewLayoutAttributes) -> UICollectionViewLayoutAttributes {
        super.preferredLayoutAttributesFitting(layoutAttributes)

        let targetSize = CGSize(width: layoutAttributes.frame.width, height: 0)

        layoutAttributes.frame.size = contentView.systemLayoutSizeFitting(targetSize, withHorizontalFittingPriority: .required, verticalFittingPriority: .fittingSizeLevel)
        print(layoutAttributes)
        return layoutAttributes
    }

    @objc private func invalidate() {
        collapsed = !collapsed
        guard let collection = superview as? UICollectionView else { return }
        collection.collectionViewLayout.invalidateLayout()
    }
}
