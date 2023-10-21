//
//  FeedNSCollectionViewCell.swift
//  FoodBowl
//
//  Created by COBY_PRO on 2023/07/22.
//

import Combine
import UIKit

import SnapKit
import Then

final class FeedNSCollectionViewCell: UICollectionViewCell, BaseViewType {

    // MARK: - ui component
    
    private let userInfoView = UserInfoView()
    private let commentLabel = UILabel().then {
        $0.font = UIFont.preferredFont(forTextStyle: .subheadline, weight: .light)
        $0.textColor = .mainTextColor
        $0.numberOfLines = 0
    }
    private let photoListView = PhotoListView()
    
    // MARK: - property
    
    var userButtonDidTapPublisher: PassthroughSubject<Void, Never> = PassthroughSubject()
    var optionButtonDidTapPublisher: PassthroughSubject<Void, Never> = PassthroughSubject()
    
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
        contentView.addSubviews(userInfoView, commentLabel, photoListView)
        
        userInfoView.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview()
            $0.height.equalTo(64)
        }
        
        commentLabel.snp.makeConstraints {
            $0.top.equalTo(userInfoView.snp.bottom)
            $0.leading.trailing.equalToSuperview().inset(SizeLiteral.horizantalPadding)
            $0.bottom.equalTo(photoListView.snp.top).offset(-4)
        }
        
        photoListView.snp.makeConstraints {
            $0.top.equalTo(commentLabel.snp.bottom).offset(6)
            $0.bottom.equalToSuperview().inset(20)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(100)
        }
    }

    func configureUI() {
        self.backgroundColor = .mainBackgroundColor
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
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
    
    // MARK: - func

    private func setupAction() {
        let userButtonTapAction = UIAction { [weak self] _ in
            self?.userButtonDidTapPublisher.send()
        }
        self.userInfoView.userImageButton.addAction(userButtonTapAction, for: .touchUpInside)
        self.userInfoView.userNameButton.addAction(userButtonTapAction, for: .touchUpInside)
        
        let optionButtonTapAction = UIAction { [weak self] _ in
            self?.optionButtonDidTapPublisher.send()
        }
        self.userInfoView.optionButton.addAction(optionButtonTapAction, for: .touchUpInside)
    }
}

// MARK: - Public - func
extension FeedNSCollectionViewCell {
    func configureCell(_ data: ReviewByStore) {
        let writer = data.writer
        let review = data.review
        
        self.userInfoView.comfigureUser(writer)
        self.commentLabel.text = review.content
        
        if review.imagePaths.isEmpty {
            self.photoListView.isHidden = true
            self.photoListView.snp.updateConstraints {
                $0.height.equalTo(0)
            }
        } else {
            self.photoListView.photos = review.imagePaths
            self.photoListView.isHidden = false
            self.photoListView.snp.updateConstraints {
                $0.height.equalTo(100)
            }
        }
    }
}
