//
//  BlameView.swift
//  FoodBowl
//
//  Created by Coby on 12/31/23.
//

import Combine
import UIKit

import SnapKit
import Then

final class BlameView: UIView, BaseViewType {
    
    // MARK: - ui component
    
    private let blameGuideLabel = PaddingLabel().then {
        $0.font = .font(.regular, ofSize: 22)
        $0.text = "신고"
        $0.textColor = .mainTextColor
        $0.padding = UIEdgeInsets(top: 0, left: 4, bottom: 0, right: 0)
        $0.frame = CGRect(x: 0, y: 0, width: 150, height: 0)
    }
    private let closeButton = UIButton().then {
        $0.setTitle("닫기", for: .normal)
        $0.setTitleColor(.mainPink, for: .normal)
        $0.titleLabel?.font = UIFont.preferredFont(forTextStyle: .headline, weight: .regular)
    }
    private let guideCommentLabel = UILabel().then {
        $0.text = "신고 내용 작성 - 사용자"
        $0.font = .font(.regular, ofSize: 17)
        $0.textColor = .mainTextColor
    }
    private lazy var commentTextView = UITextView().then {
        $0.textContainerInset = UIEdgeInsets(top: 12, left: 10, bottom: 12, right: 10)
        $0.font = UIFont.preferredFont(forTextStyle: .subheadline, weight: .light)
        $0.textAlignment = NSTextAlignment.left
        $0.dataDetectorTypes = UIDataDetectorTypes.all
        $0.textColor = .grey001
        $0.isEditable = true
        $0.delegate = self
        $0.isScrollEnabled = true
        $0.isUserInteractionEnabled = true
        $0.makeBorderLayer(color: .grey002)
        $0.backgroundColor = .clear
        $0.text = textViewPlaceHolder
    }
    private let completeButton = CompleteButton()
    
    // MARK: - property
    
    private let textViewPlaceHolder = "100자 이내"
    var closeButtonDidTapPublisher: AnyPublisher<Void, Never> {
        return self.closeButton.buttonTapPublisher
    }
    let completeButtonDidTapPublisher = PassthroughSubject<String, Never>()
    
    // MARK: - init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.baseInit()
        self.setupAction()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - func
    
    func configureNavigationBarItem(_ navigationController: UINavigationController) {
        let navigationItem = navigationController.topViewController?.navigationItem
        let blameGuideLabel = navigationController.makeBarButtonItem(with: blameGuideLabel)
        let closeButton = navigationController.makeBarButtonItem(with: closeButton)
        navigationItem?.leftBarButtonItem = blameGuideLabel
        navigationItem?.rightBarButtonItem = closeButton
    }
    
    // MARK: - base func
    
    func setupLayout() {
        self.addSubviews(
            self.guideCommentLabel,
            self.commentTextView,
            self.completeButton
        )

        self.guideCommentLabel.snp.makeConstraints {
            $0.top.equalTo(self.safeAreaLayoutGuide.snp.top).offset(20)
            $0.leading.equalToSuperview().inset(SizeLiteral.horizantalPadding)
        }

        self.commentTextView.snp.makeConstraints {
            $0.top.equalTo(self.guideCommentLabel.snp.bottom).offset(10)
            $0.leading.trailing.equalToSuperview().inset(SizeLiteral.horizantalPadding)
            $0.height.equalTo(100)
        }

        self.completeButton.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(SizeLiteral.horizantalPadding)
            $0.bottom.equalToSuperview().inset(SizeLiteral.bottomPadding)
            $0.height.equalTo(60)
        }
    }
    
    func configureUI() {
        self.backgroundColor = .mainBackgroundColor
    }
    
    // MARK: - Private - func

    private func setupAction() {
        let completeAction = UIAction { [weak self] _ in
            guard let self = self else { return }
            self.completeButtonDidTapPublisher.send(self.commentTextView.text)
        }
        self.completeButton.addAction(completeAction, for: .touchUpInside)
    }
}

extension BlameView: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.text == textViewPlaceHolder {
            textView.text = nil
            textView.textColor = .mainTextColor
        }
    }

    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            textView.text = textViewPlaceHolder
            textView.textColor = .grey001
        }
    }
}
