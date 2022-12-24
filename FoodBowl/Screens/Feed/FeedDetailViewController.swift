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
        $0.frame.size.width = 30
        $0.frame.size.height = 30
        $0.layer.cornerRadius = 15
        $0.backgroundColor = .white.withAlphaComponent(0.7)
        let buttonAction = UIAction { [weak self] _ in
            self?.navigationController?.popViewController(animated: true)
        }
        $0.addAction(buttonAction, for: .touchUpInside)
    }

    lazy var horizontalScrollView = HorizontalScrollView(horizontalWidth: UIScreen.main.bounds.size.width, horizontalHeight: UIScreen.main.bounds.size.width)

    // MARK: - life cycle

    override func render() {
        view.addSubviews(horizontalScrollView)

        horizontalScrollView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide)
            $0.leading.trailing.equalToSuperview()
            $0.width.height.equalTo(UIScreen.main.bounds.size.width)
        }
    }

    override func configUI() {
        super.configUI()
        horizontalScrollView.model = [ImageLiteral.food1, ImageLiteral.food2, ImageLiteral.food3]
    }

    override func setupNavigationBar() {
        super.setupNavigationBar()
        let appearance = UINavigationBarAppearance()
        appearance.configureWithTransparentBackground()

        let backButton = makeBarButtonItem(with: backButton)
        navigationItem.leftBarButtonItem = backButton
    }
}
