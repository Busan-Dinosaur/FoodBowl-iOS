//
//  FindStoreViewController.swift
//  FoodBowl
//
//  Created by COBY_PRO on 2023/01/18.
//

import UIKit

import SnapKit
import Then

final class FindStoreViewController: BaseViewController {
    private lazy var cancelButton = UIButton().then {
        $0.setTitle("취소", for: .normal)
        $0.setTitleColor(.mainPink, for: .normal)
        $0.titleLabel?.font = UIFont.preferredFont(forTextStyle: .headline, weight: .regular)
        let buttonAction = UIAction { [weak self] _ in
            self?.dismiss(animated: true, completion: nil)
        }
        $0.addAction(buttonAction, for: .touchUpInside)
    }

    private lazy var searchBar = UISearchBar().then {
        $0.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width - 80, height: 0)
        $0.placeholder = "가게의 이름을 검색해주세요."
        $0.delegate = self
    }

    override func setupNavigationBar() {
        let cancelButton = makeBarButtonItem(with: cancelButton)
        navigationItem.rightBarButtonItem = cancelButton
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: searchBar)
    }
}

extension FindStoreViewController: UISearchBarDelegate {
    private func dissmissKeyboard() {
        searchBar.resignFirstResponder()
    }

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        dissmissKeyboard()
        guard let searchTerm = searchBar.text, searchTerm.isEmpty == false else { return }
        print(searchTerm)
    }
}
