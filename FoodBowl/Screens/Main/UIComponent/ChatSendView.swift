//
//  ChatSendView.swift
//  FoodBowl
//
//  Created by COBY_PRO on 2023/01/28.
//

import UIKit

import SnapKit
import Then

final class ChatSendView: UIView {
    // MARK: - Property

    let chatTextField = UITextView().then {
        $0.font = UIFont.preferredFont(forTextStyle: .body, weight: .light)
        $0.textColor = .subText
        $0.textAlignment = NSTextAlignment.left
        $0.dataDetectorTypes = UIDataDetectorTypes.all
        $0.isEditable = true
        $0.autocapitalizationType = .none
        $0.isScrollEnabled = false
        $0.textContainerInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 5)
    }

    let chatSendbutton = SendButton().then {
        $0.tintColor = .white
        $0.backgroundColor = .mainBlue
        $0.layer.cornerRadius = 15
        $0.layer.masksToBounds = true
    }

    // MARK: - init

    override init(frame: CGRect) {
        super.init(frame: frame)
        render()
        configUI()
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - func

    private func render() {
        addSubviews(chatTextField, chatSendbutton)

        snp.makeConstraints {
            $0.width.equalTo(UIScreen.main.bounds.size.width)
            $0.bottom.equalTo(chatTextField.snp.bottom)
        }

        chatTextField.snp.makeConstraints {
            $0.top.bottom.leading.equalToSuperview()
            $0.trailing.equalTo(chatSendbutton.snp.leading)
        }

        chatSendbutton.snp.makeConstraints {
            $0.width.height.equalTo(30)
            $0.trailing.equalToSuperview()
            $0.bottom.trailing.equalToSuperview().inset(5)
        }
    }

    private func configUI() {
        layer.borderWidth = 0.3
        layer.borderColor = UIColor.subText.cgColor
        layer.cornerRadius = 20
        backgroundColor = .white
    }
}
