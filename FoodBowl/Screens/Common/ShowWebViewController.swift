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

final class ShowWebViewController: BaseViewController, WKNavigationDelegate, WKUIDelegate {
    var url = ""

    // MARK: - property
    lazy var webView = WKWebView(frame: .zero, configuration: WKWebViewConfiguration()).then {
        $0.navigationDelegate = self
        $0.uiDelegate = self
        $0.translatesAutoresizingMaskIntoConstraints = false
    }

    // MARK: - life cycle
    override func setupLayout() {
        view.addSubviews(webView)

        webView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide)
            $0.leading.trailing.bottom.equalToSuperview()
        }

        DispatchQueue.main.async {
            if let url = URL(string: self.url) { self.webView.load(URLRequest(url: url)) }
        }
    }

    override func setupNavigationBar() {
        super.setupNavigationBar()
        let closeButton = makeBarButtonItem(with: closeButton)
        navigationItem.rightBarButtonItem = closeButton
        navigationItem.leftBarButtonItem = nil
    }

    func webView(
        _: WKWebView,
        decidePolicyFor navigationAction: WKNavigationAction,
        decisionHandler: @escaping (WKNavigationActionPolicy) -> Void
    ) {
        if let url = navigationAction.request.url, url.scheme != "http" && url.scheme != "https" {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
            decisionHandler(.cancel)
        } else {
            decisionHandler(.allow)
        }
    }
}
