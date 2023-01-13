//
//  SetStoreViewController.swift
//  FoodBowl
//
//  Created by COBY_PRO on 2022/12/23.
//

import UIKit

import SnapKit
import Then

final class SetStoreViewController: BaseViewController {
    // MARK: - property

    private let guideLabel = UILabel().then {
        $0.numberOfLines = 0
        let guide = NSAttributedString(string: "피드를 작성할\n가게를 찾아보세요.").withLineSpacing(10)
        $0.attributedText = guide
        $0.font = UIFont.preferredFont(forTextStyle: .title3, weight: .medium)
    }
    
    lazy var searchBarButton = SearchBarButton().then {
        $0.label.text = "가게 검색"
        let action = UIAction { [weak self] _ in
            let searchStoreViewController = SearchStoreViewController()
            searchStoreViewController.modalPresentationStyle = .pageSheet
//            searchStoreViewController.sheetPresentationController?.detents = [.medium()]

            self?.present(searchStoreViewController, animated: true, completion: nil)
        }
        $0.addAction(action, for: .touchUpInside)
    }

    // MARK: - life cycle

    override func render() {
        view.addSubviews(guideLabel, searchBarButton)
        
        guideLabel.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top).inset(20)
            $0.leading.equalToSuperview().inset(20)
        }
        
        searchBarButton.snp.makeConstraints {
            $0.top.equalTo(guideLabel.snp.bottom).offset(20)
            $0.leading.trailing.equalToSuperview().inset(20)
            $0.height.equalTo(40)
        }
    }
}
