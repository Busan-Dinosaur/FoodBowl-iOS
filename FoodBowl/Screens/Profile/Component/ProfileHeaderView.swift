//
//  ProfileHeaderView.swift
//  FoodBowl
//
//  Created by COBY_PRO on 2022/12/24.
//

import UIKit

import SnapKit
import Then

final class ProfileHeaderView: UICollectionReusableView {
    enum Size {
        static let SearchBarWidth: CGFloat = BaseSize.fullWidth - BaseSize.horizantalPadding - 30
    }

    private let categories = Category.allCases

    // MARK: - property
    lazy var userImageView = UIImageView().then {
        $0.backgroundColor = .grey001
        $0.layer.cornerRadius = 25
        $0.layer.masksToBounds = true
    }

    let followerInfoButton = UserInfoButton().then {
        $0.infoLabel.text = "팔로워"
        $0.numberLabel.text = "100"
    }

    let followingInfoButton = UserInfoButton().then {
        $0.infoLabel.text = "팔로잉"
        $0.numberLabel.text = "100"
    }

    let followButton = FollowButton()

    let editButton = UIButton().then {
        $0.setTitle("프로필 수정", for: .normal)
        $0.setTitleColor(.white, for: .normal)
        $0.titleLabel?.font = UIFont.preferredFont(forTextStyle: .footnote, weight: .medium)
        $0.layer.cornerRadius = 15
        $0.backgroundColor = .mainBlue
    }

    private let collectionViewFlowLayout = UICollectionViewFlowLayout().then {
        $0.scrollDirection = .horizontal
        $0.sectionInset = BaseSize.collectionInset
        $0.minimumLineSpacing = 6
        $0.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
    }

    private lazy var listCollectionView = UICollectionView(frame: .zero, collectionViewLayout: collectionViewFlowLayout).then {
        $0.backgroundColor = .clear
        $0.dataSource = self
        $0.delegate = self
        $0.showsHorizontalScrollIndicator = false
        $0.allowsMultipleSelection = true
        $0.register(CategoryCollectionViewCell.self, forCellWithReuseIdentifier: CategoryCollectionViewCell.className)
    }

    // MARK: - init
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupLayout()
        configureUI()
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - life cycle

    private func setupLayout() {
        addSubviews(userImageView, followerInfoButton, followingInfoButton, listCollectionView)

        userImageView.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(20)
            $0.top.equalToSuperview().inset(10)
            $0.width.height.equalTo(50)
        }

        followerInfoButton.snp.makeConstraints {
            $0.leading.equalTo(userImageView.snp.trailing).offset(40)
            $0.top.equalToSuperview().inset(15)
        }

        followingInfoButton.snp.makeConstraints {
            $0.leading.equalTo(followerInfoButton.snp.trailing).offset(40)
            $0.top.equalToSuperview().inset(15)
        }

        listCollectionView.snp.makeConstraints {
            $0.top.equalTo(userImageView.snp.bottom).offset(20)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(30)
        }
    }

    private func configureUI() {
        backgroundColor = .mainBackground
    }
}

// MARK: - UICollectionViewDataSource, UICollectionViewDelegate
extension ProfileHeaderView: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_: UICollectionView, numberOfItemsInSection _: Int) -> Int {
        return categories.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: CategoryCollectionViewCell.className,
            for: indexPath
        ) as? CategoryCollectionViewCell else {
            return UICollectionViewCell()
        }
        cell.categoryLabel.text = categories[indexPath.item].rawValue

        return cell
    }

    func collectionView(_: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print(categories[indexPath.item].rawValue)
    }
}
