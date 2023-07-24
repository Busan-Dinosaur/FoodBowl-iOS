//
//  SearchChooseViewController.swift
//  FoodBowl
//
//  Created by COBY_PRO on 2023/07/24.
//

import UIKit

import SnapKit
import Then

final class SearchChooseViewController: BaseViewController {
    // MARK: - property
    private lazy var closeButton = CloseButton().then {
        let action = UIAction { [weak self] _ in
            self?.dismiss(animated: true, completion: nil)
        }
        $0.addAction(action, for: .touchUpInside)
    }

    private let guideLabel = UILabel().then {
        $0.text = "맛집과 유저를 이름으로 찾아보세요."
        $0.font = UIFont.preferredFont(forTextStyle: .body, weight: .medium)
        $0.textColor = .mainText
    }

    lazy var searchStoreButton = SearchBarButton().then {
        $0.placeholderLabel.text = "가게 검색"
    }

    lazy var searchUserButton = SearchBarButton().then {
        $0.placeholderLabel.text = "친구 검색"
    }

    // MARK: - life cycle
    override func setupLayout() {
        view.addSubviews(guideLabel, searchStoreButton, searchUserButton)

        guideLabel.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top).inset(20)
            $0.leading.equalToSuperview().inset(BaseSize.horizantalPadding)
        }

        searchStoreButton.snp.makeConstraints {
            $0.top.equalTo(guideLabel.snp.bottom).offset(20)
            $0.leading.trailing.equalToSuperview().inset(BaseSize.horizantalPadding)
            $0.height.equalTo(40)
        }

        searchUserButton.snp.makeConstraints {
            $0.top.equalTo(searchStoreButton.snp.bottom).offset(10)
            $0.leading.trailing.equalToSuperview().inset(BaseSize.horizantalPadding)
            $0.height.equalTo(40)
        }
    }

    override func setupNavigationBar() {
        super.setupNavigationBar()

        let leftOffsetCloseButton = removeBarButtonItemOffset(with: closeButton, offsetX: 10)
        let closeButton = makeBarButtonItem(with: leftOffsetCloseButton)
        navigationItem.leftBarButtonItem = closeButton
        title = "찾기"
    }
}
