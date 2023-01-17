//
//  SearchViewController.swift
//  FoodBowl
//
//  Created by COBY_PRO on 2022/12/23.
//

import UIKit

import SnapKit
import Then

final class SearchViewController: BaseViewController {
    // MARK: - property

    private lazy var searchBarButton = SearchBarButton().then {
        $0.label.text = "새로운 가게와 유저를 찾아보세요."
        let action = UIAction { [weak self] _ in
        }
        $0.addAction(action, for: .touchUpInside)
    }

    // MARK: - life cycle

    override func render() {
        view.addSubviews(searchBarButton)

        searchBarButton.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide)
            $0.leading.trailing.equalToSuperview().inset(20)
            $0.height.equalTo(50)
        }
    }

    override func setupNavigationBar() {
        navigationController?.isNavigationBarHidden = true
    }
}
