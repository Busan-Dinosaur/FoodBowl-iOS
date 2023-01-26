//
//  SettingViewController.swift
//  FoodBowl
//
//  Created by COBY_PRO on 2023/01/26.
//

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
    }

    // MARK: - life cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setupSettingItems()
    }

    override func render() {
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
        options.append(Option(title: "친구초대", handler: { [weak self] in
        }))

        options.append(Option(title: "공지사항", handler: { [weak self] in
        }))

        options.append(Option(title: "고객센터", handler: { [weak self] in
        }))

        options.append(Option(title: "개인정보처리방침", handler: { [weak self] in
        }))

        options.append(Option(title: "이용약관", handler: { [weak self] in
        }))

        options.append(Option(title: "로그아웃", handler: { [weak self] in
        }))
    }
}

extension SettingViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_: UITableView, numberOfRowsInSection _: Int) -> Int {
        return options.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: SettingItemTableViewCell.className, for: indexPath) as? SettingItemTableViewCell else { return UITableViewCell() }

        cell.selectionStyle = .none
        cell.menuLabel.text = options[indexPath.item].title

        return cell
    }

    func tableView(_: UITableView, heightForRowAt _: IndexPath) -> CGFloat {
        return 60
    }

    func tableView(_: UITableView, didSelectRowAt indexPath: IndexPath) {
        let model = options[indexPath.row]
        model.handler()
    }
}

struct Option {
    let title: String
    let handler: () -> Void
}
