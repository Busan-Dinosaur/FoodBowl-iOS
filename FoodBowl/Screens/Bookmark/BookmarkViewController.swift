//
//  BookmarkViewController.swift
//  FoodBowl
//
//  Created by COBY_PRO on 2023/07/06.
//

import UIKit

import SnapKit
import Then

final class BookmarkViewController: BaseViewController {
    // MARK: - property
    let guideLabel = UILabel().then {
        $0.font = UIFont.preferredFont(forTextStyle: .footnote, weight: .light)
        $0.textColor = .subText
        $0.text = "북마크"
    }

    // MARK: - life cycle

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func setupLayout() {
        view.addSubviews(guideLabel)

        guideLabel.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }

    override func setupNavigationBar() {
        navigationController?.isNavigationBarHidden = true
    }
}
