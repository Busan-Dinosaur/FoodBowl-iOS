//
//  ShowWebViewController.swift
//  FoodBowl
//
//  Created by COBY_PRO on 2023/01/15.
//

import UIKit

import SnapKit
import Then
import WebKit

final class ShowWebViewController: BaseViewController {
    var url = ""

    // MARK: - property

    private lazy var closeButton = CloseButton().then {
        let action = UIAction { [weak self] _ in
            self?.dismiss(animated: true, completion: nil)
        }
        $0.addAction(action, for: .touchUpInside)
    }

    let webView = WKWebView()

    // MARK: - life cycle

    override func render() {
        view.addSubviews(webView)

        webView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide)
            $0.leading.trailing.bottom.equalToSuperview()
        }
    }

    override func configUI() {
        if let url = URL(string: url) {
            let request = URLRequest(url: url)
            webView.load(request)
        }
    }

    override func setupNavigationBar() {
        super.setupNavigationBar()

        let leftOffsetCloseButton = removeBarButtonItemOffset(with: closeButton, offsetX: 10)
        let closeButton = makeBarButtonItem(with: leftOffsetCloseButton)
        navigationItem.leftBarButtonItem = closeButton
    }
}
