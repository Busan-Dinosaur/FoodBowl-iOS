//
//  ChatViewController.swift
//  FoodBowl
//
//  Created by COBY_PRO on 2023/01/18.
//

import MessageUI
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
        $0.backgroundColor = .clear
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
        guard let cell = tableView
            .dequeueReusableCell(withIdentifier: ChatTableViewCell.className, for: indexPath) as? ChatTableViewCell
        else { return UITableViewCell() }

        cell.selectionStyle = .none

        cell.userButtonTapAction = { [weak self] _ in
            let profileViewController = ProfileViewController(isOwn: false)
            self?.navigationController?.pushViewController(profileViewController, animated: true)
        }

        cell.optionButtonTapAction = { [weak self] _ in
            let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)

            let report = UIAlertAction(title: "신고하기", style: .destructive, handler: { _ in
                self?.sendReportMail()
            })
            let cancel = UIAlertAction(title: "취소", style: .cancel, handler: nil)

            alert.addAction(cancel)
            alert.addAction(report)

            self?.present(alert, animated: true, completion: nil)
        }

        cell.userImageButton.setImage(ImageLiteral.food2, for: .normal)
        cell.userChatLabel.text = "맛있었어요"

        return cell
    }

    func tableView(_: UITableView, estimatedHeightForRowAt _: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}

extension ChatViewController: MFMailComposeViewControllerDelegate {
    func sendReportMail() {
        if MFMailComposeViewController.canSendMail() {
            let composeVC = MFMailComposeViewController()
            let emailAdress = "foodbowl5502@gmail.com"
            let messageBody = """
                신고 사유를 작성해주세요.
                """

            composeVC.mailComposeDelegate = self
            composeVC.setToRecipients([emailAdress])
            composeVC.setSubject("[신고] 닉네임")
            composeVC.setMessageBody(messageBody, isHTML: false)
            composeVC.modalPresentationStyle = .fullScreen

            present(composeVC, animated: true, completion: nil)
        } else {
            showSendMailErrorAlert()
        }
    }

    private func showSendMailErrorAlert() {
        let sendMailErrorAlert = UIAlertController(title: "메일 전송 실패", message: "이메일 설정을 확인하고 다시 시도해주세요.", preferredStyle: .alert)
        let confirmAction = UIAlertAction(title: "확인", style: .default)
        sendMailErrorAlert.addAction(confirmAction)
        present(sendMailErrorAlert, animated: true, completion: nil)
    }

    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith _: MFMailComposeResult, error _: Error?) {
        controller.dismiss(animated: true, completion: nil)
    }
}
