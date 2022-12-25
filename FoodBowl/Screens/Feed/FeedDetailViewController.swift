//
//  FeedDetailViewController.swift
//  FoodBowl
//
//  Created by COBY_PRO on 2022/12/23.
//

import UIKit

import SnapKit
import Then

final class FeedDetailViewController: BaseViewController {
    var images: [String] = ["image1", "image2", "image3"]

    // MARK: - property

    private lazy var backButton = BackButton().then {
        $0.layer.cornerRadius = 15
        $0.backgroundColor = .white.withAlphaComponent(0.7)
        let buttonAction = UIAction { [weak self] _ in
            self?.dismiss(animated: true, completion: nil)
        }
        $0.addAction(buttonAction, for: .touchUpInside)
    }

    private lazy var scrapButton = ScrapButton().then {
        $0.layer.cornerRadius = 15
        $0.backgroundColor = .white.withAlphaComponent(0.7)
        let buttonAction = UIAction { [weak self] _ in
            self?.dismiss(animated: true, completion: nil)
        }
        $0.addAction(buttonAction, for: .touchUpInside)
    }

    lazy var horizontalScrollView = HorizontalScrollView(horizontalWidth: UIScreen.main.bounds.size.width, horizontalHeight: UIScreen.main.bounds.size.width)

    lazy var userInfoView = UserInfoView().then {
        $0.userImageView.image = ImageLiteral.food2
    }

    lazy var storeInfoView = StoreInfoView()

    // MARK: - life cycle

    override func render() {
        view.addSubviews(horizontalScrollView, backButton, scrapButton, userInfoView, storeInfoView)

        horizontalScrollView.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview()
            $0.width.height.equalTo(UIScreen.main.bounds.size.width)
        }

        backButton.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).inset(10)
            $0.leading.equalToSuperview().inset(20)
            $0.width.height.equalTo(30)
        }

        scrapButton.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).inset(10)
            $0.trailing.equalToSuperview().inset(20)
            $0.width.height.equalTo(30)
        }

        userInfoView.snp.makeConstraints {
            $0.top.equalTo(horizontalScrollView.snp.bottom)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(70)
        }

        storeInfoView.snp.makeConstraints {
            $0.top.equalTo(userInfoView.snp.bottom)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(100)
        }
    }

    override func configUI() {
        super.configUI()
        horizontalScrollView.model = [ImageLiteral.food1, ImageLiteral.food2, ImageLiteral.food3]
    }

    override func setupNavigationBar() {
        super.setupNavigationBar()
        guard let navigationBar = navigationController?.navigationBar else { return }
        let appearance = UINavigationBarAppearance()
        appearance.configureWithTransparentBackground()
        navigationBar.standardAppearance = appearance
        navigationBar.compactAppearance = appearance
        navigationBar.scrollEdgeAppearance = appearance

        let backButton = makeBarButtonItem(with: backButton)
        navigationItem.leftBarButtonItem = backButton
    }
}
