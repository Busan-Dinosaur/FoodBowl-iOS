//
//  SettingViewController.swift
//  FoodBowl
//
//  Created by COBY_PRO on 2023/01/26.
//

import MessageUI
import UIKit

import SnapKit
import Then

final class SettingViewController: BaseViewController {
    private var options = [Option]()

    // MARK: - property

    private lazy var settingItemTableView = UITableView().then {
        $0.register(SettingItemTableViewCell.self, forCellReuseIdentifier: SettingItemTableViewCell.className)
        $0.delegate = self
        $0.dataSource = self
        $0.separatorStyle = .none
        $0.backgroundColor = .clear
    }

    // MARK: - life cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setupSettingItems()
    }

    override func setupLayout() {
        view.addSubviews(settingItemTableView)

        settingItemTableView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }

    override func setupNavigationBar() {
        super.setupNavigationBar()
        title = "설정"
    }

    private func setupSettingItems() {
        options.append(Option(title: "공지사항", handler: { [weak self] in
            let showWebViewController = ShowWebViewController()
            showWebViewController.title = "공지사항"
            showWebViewController.url = "https://coby5502.notion.site/a25fe63009d24b958fe77ab87e53994e"
            let navigationController = UINavigationController(rootViewController: showWebViewController)
            navigationController.modalPresentationStyle = .fullScreen
            DispatchQueue.main.async {
                self?.present(navigationController, animated: true)
            }
        }))

        options.append(Option(title: "개인정보처리방침", handler: { [weak self] in
            let showWebViewController = ShowWebViewController()
            showWebViewController.title = "개인정보처리방침"
            showWebViewController.url = "https://coby5502.notion.site/2ca079dd7b354cd790b3280728ebb0d5"
            let navigationController = UINavigationController(rootViewController: showWebViewController)
            navigationController.modalPresentationStyle = .fullScreen
            DispatchQueue.main.async {
                self?.present(navigationController, animated: true)
            }
        }))

        options.append(Option(title: "이용약관", handler: { [weak self] in
            let showWebViewController = ShowWebViewController()
            showWebViewController.title = "이용약관"
            showWebViewController.url = "https://coby5502.notion.site/32da9811cd284eaab7c3d8390c0ddccc"
            let navigationController = UINavigationController(rootViewController: showWebViewController)
            navigationController.modalPresentationStyle = .fullScreen
            DispatchQueue.main.async {
                self?.present(navigationController, animated: true)
            }
        }))

        options.append(Option(title: "문의하기", handler: { [weak self] in
            self?.sendReportMail()
        }))

        options.append(Option(title: "로그아웃", handler: { [weak self] in
            DispatchQueue.main.async {
                self?.makeRequestAlert(title: "로그아웃 하시겠습니까?", message: "", okTitle: "확인", cancelTitle: "취소", okAction: { _ in
                    guard let sceneDelegate = UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate
                    else { return }
                    sceneDelegate.logout()
                })
            }
        }))

        options.append(Option(title: "회원탈퇴", handler: { [weak self] in
        }))
    }
}

extension SettingViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_: UITableView, numberOfRowsInSection _: Int) -> Int {
        return options.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView
            .dequeueReusableCell(withIdentifier: SettingItemTableViewCell.className, for: indexPath) as? SettingItemTableViewCell
        else { return UITableViewCell() }

        cell.selectionStyle = .none
        cell.menuLabel.text = options[indexPath.item].title

        return cell
    }

    func tableView(_: UITableView, heightForRowAt _: IndexPath) -> CGFloat {
        return 50
    }

    func tableView(_: UITableView, didSelectRowAt indexPath: IndexPath) {
        options[indexPath.item].handler()
    }
}

struct Option {
    let title: String
    let handler: () -> Void
}
