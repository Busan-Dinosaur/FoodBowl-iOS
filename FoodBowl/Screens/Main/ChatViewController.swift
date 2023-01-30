//
//  ChatViewController.swift
//  FoodBowl
//
//  Created by COBY_PRO on 2023/01/18.
//

import UIKit

import SnapKit
import Then

final class ChatViewController: BaseViewController {
    // MARK: - property

    private lazy var chatTableView = UITableView().then {
        $0.register(ChatTableViewCell.self, forCellReuseIdentifier: ChatTableViewCell.className)
        $0.delegate = self
        $0.dataSource = self
        $0.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 20, right: 0)
        $0.rowHeight = UITableView.automaticDimension
        $0.estimatedRowHeight = 60
        $0.showsVerticalScrollIndicator = false
    }

    private lazy var chatSendView = ChatSendView().then {
        let action = UIAction { [weak self] _ in
            self?.didTapChatSendbutton()
        }
        $0.chatSendbutton.addAction(action, for: .touchUpInside)
    }

    // MARK: - life cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        hidekeyboardWhenTappedAroundExceptSendView()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabBarController?.tabBar.isHidden = true
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        tabBarController?.tabBar.isHidden = false
    }

    override func render() {
        view.addSubviews(chatSendView, chatTableView)

        chatSendView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(10)
            $0.bottom.equalTo(view.keyboardLayoutGuide.snp.top).offset(-5)
        }

        chatTableView.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview()
            $0.bottom.equalTo(chatSendView.snp.top).offset(-5)
        }
    }

    override func setupNavigationBar() {
        super.setupNavigationBar()
        title = "댓글"
    }

    private func scrollToBottom() {
//        DispatchQueue.main.async {
//            let index = self.chatMessages.count - 1
//            if index >= 0 {
//                let indexPath = IndexPath(row: index, section: 0)
//                self.chatTableView.scrollToRow(at: indexPath, at: .bottom, animated: true)
//            }
//        }
    }

    func hidekeyboardWhenTappedAroundExceptSendView() {
        view.gestureRecognizers?.removeAll()
        let tap = UITapGestureRecognizer(target: self, action: #selector(endEditingView))
        tap.cancelsTouchesInView = false
        chatTableView.addGestureRecognizer(tap)
    }

    private func didTapChatSendbutton() {
        chatSendView.chatTextField.text = ""
    }
}

extension ChatViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_: UITableView, numberOfRowsInSection _: Int) -> Int {
        return 10
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ChatTableViewCell.className, for: indexPath) as? ChatTableViewCell else { return UITableViewCell() }

        cell.selectionStyle = .none

        let userButtonAction = UIAction { [weak self] _ in
            let profileViewController = ProfileViewController(isOwn: false)
            self?.navigationController?.pushViewController(profileViewController, animated: true)
        }

        cell.userImageButton.addAction(userButtonAction, for: .touchUpInside)
        cell.userNameButton.addAction(userButtonAction, for: .touchUpInside)

        cell.userImageButton.setImage(ImageLiteral.food2, for: .normal)
        cell.userChatLabel.text = "맛있었어요"

        return cell
    }

    func tableView(_: UITableView, estimatedHeightForRowAt _: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}
