//
//  ProfileViewController.swift
//  FoodBowl
//
//  Created by COBY_PRO on 2022/12/23.
//

import UIKit

import SnapKit
import Then

final class ProfileViewController: BaseViewController {
    private enum Size {
        static let cellWidth: CGFloat = (UIScreen.main.bounds.size.width - 8) / 3
        static let cellHeight: CGFloat = cellWidth
        static let collectionInset = UIEdgeInsets(top: 0,
                                                  left: 0,
                                                  bottom: 20,
                                                  right: 0)
    }

    private var feeds: [String] = ["가나", "다라", "마바", "사아", "자차", "사아", "자차", "사아", "자차", "사아", "자차"]

    // MARK: - property

    private let settingButton = SettingButton()

    private let userProfileView = UserProfileView()

    private let collectionViewFlowLayout = UICollectionViewFlowLayout().then {
        $0.scrollDirection = .vertical
        $0.sectionInset = Size.collectionInset
        $0.itemSize = CGSize(width: Size.cellWidth, height: Size.cellHeight)
        $0.minimumLineSpacing = 4
        $0.minimumInteritemSpacing = 4
    }

    private lazy var listCollectionView = UICollectionView(frame: .zero, collectionViewLayout: collectionViewFlowLayout).then {
        $0.backgroundColor = .clear
        $0.dataSource = self
        $0.delegate = self
        $0.showsVerticalScrollIndicator = false
        $0.register(FeedThumnailCollectionViewCell.self, forCellWithReuseIdentifier: FeedThumnailCollectionViewCell.className)
    }

    // MARK: - life cycle

    override func render() {
        view.addSubviews(userProfileView, listCollectionView)

        userProfileView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(220)
        }

        listCollectionView.snp.makeConstraints {
            $0.top.equalTo(userProfileView.snp.bottom).offset(20)
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalToSuperview().inset(20)
        }
    }

    override func setupNavigationBar() {
        super.setupNavigationBar()

        let settingButton = makeBarButtonItem(with: settingButton)
        navigationItem.leftBarButtonItem = nil
        navigationItem.rightBarButtonItem = settingButton
        title = "coby5502"
    }
}

extension ProfileViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_: UICollectionView, numberOfItemsInSection _: Int) -> Int {
        return feeds.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FeedThumnailCollectionViewCell.className, for: indexPath) as? FeedThumnailCollectionViewCell else {
            return UICollectionViewCell()
        }

        return cell
    }

    func collectionView(_: UICollectionView, didSelectItemAt _: IndexPath) {}
}
