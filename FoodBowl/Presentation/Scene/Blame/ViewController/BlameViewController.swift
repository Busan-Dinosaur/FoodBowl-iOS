//
//  BlameViewController.swift
//  FoodBowl
//
//  Created by COBY_PRO on 10/13/23.
//

import UIKit

import Moya
import SnapKit
import Then

final class BlameViewController: BaseViewController {
    private enum Size {
        static let cellWidth: CGFloat = 100
        static let cellHeight: CGFloat = cellWidth
        static let collectionInset = UIEdgeInsets(
            top: 0,
            left: 20,
            bottom: 0,
            right: 20
        )
    }

    private let targetId: Int
    private let blameTarget: String

    private let textViewPlaceHolder = "100자 이내"

    init(targetId: Int, blameTarget: String) {
        self.targetId = targetId
        self.blameTarget = blameTarget
        super.init()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - property
    private let blameGuideLabel = PaddingLabel().then {
        $0.font = .font(.regular, ofSize: 22)
        $0.text = "신고"
        $0.textColor = .mainTextColor
        $0.padding = UIEdgeInsets(top: 0, left: 4, bottom: 0, right: 0)
        $0.frame = CGRect(x: 0, y: 0, width: 150, height: 0)
    }

    private lazy var closeButton = UIButton().then {
        $0.setTitle("닫기", for: .normal)
        $0.setTitleColor(.mainPink, for: .normal)
        $0.titleLabel?.font = UIFont.preferredFont(forTextStyle: .headline, weight: .regular)
        let action = UIAction { [weak self] _ in
            self?.dismiss(animated: true)
        }
        $0.addAction(action, for: .touchUpInside)
    }

    private lazy var guideCommentLabel = UILabel().then {
        $0.text = "신고 내용 작성 - \(self.blameTarget == "MEMBER" ? "사용자" : "후기")"
        $0.font = .font(.regular, ofSize: 17)
        $0.textColor = .mainTextColor
    }

    private lazy var commentTextView = UITextView().then {
        $0.textContainerInset = UIEdgeInsets(top: 12, left: 10, bottom: 12, right: 10)
        $0.font = UIFont.preferredFont(forTextStyle: .subheadline, weight: .light)
        $0.textAlignment = NSTextAlignment.left
        $0.dataDetectorTypes = UIDataDetectorTypes.all
        $0.text = textViewPlaceHolder
        $0.textColor = .grey001
        $0.isEditable = true
        $0.delegate = self
        $0.isScrollEnabled = true
        $0.isUserInteractionEnabled = true
        $0.makeBorderLayer(color: .grey002)
        $0.backgroundColor = .clear
    }

    private lazy var completeButton = MainButton().then {
        $0.label.text = "완료"
        let action = UIAction { [weak self] _ in
            self?.tappedCompleteButton()
        }
        $0.addAction(action, for: .touchUpInside)
    }

    // MARK: - life cycle
    override func setupLayout() {
        view.addSubviews(
            guideCommentLabel,
            commentTextView,
            completeButton
        )

        guideCommentLabel.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(20)
            $0.leading.equalToSuperview().inset(SizeLiteral.horizantalPadding)
        }

        commentTextView.snp.makeConstraints {
            $0.top.equalTo(guideCommentLabel.snp.bottom).offset(10)
            $0.leading.trailing.equalToSuperview().inset(SizeLiteral.horizantalPadding)
            $0.height.equalTo(100)
        }

        completeButton.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(SizeLiteral.horizantalPadding)
            $0.bottom.equalToSuperview().inset(SizeLiteral.bottomPadding)
            $0.height.equalTo(60)
        }
    }

    override func setupNavigationBar() {
        let blameGuideLabel = makeBarButtonItem(with: blameGuideLabel)
        let closeButton = makeBarButtonItem(with: closeButton)
        navigationItem.leftBarButtonItem = blameGuideLabel
        navigationItem.rightBarButtonItem = closeButton
    }

    private func tappedCompleteButton() {
        if commentTextView.text == "" {
            makeAlert(title: "신고 내용을 작성해주세요.")
            return
        }

        createBlame()
    }

    private func createBlame() {
        let providerService = MoyaProvider<ServiceAPI>()

        providerService.request(
            .createBlame(
                request: CreateBlameRequestDTO(
                    targetId: targetId,
                    blameTarget: blameTarget,
                    description: commentTextView.text
                )
            )
        ) { response in
            switch response {
            case .success:
                self.dismiss(animated: true)
            case .failure(let error):
                if let errorResponse = error.errorResponse {
                    print("에러 코드: \(errorResponse.errorCode)")
                    print("에러 메시지: \(errorResponse.message)")
                    self.makeAlert(title: errorResponse.message)
                } else {
                    print("네트워크 에러: \(error.localizedDescription)")
                }
            }
        }
    }
}

extension BlameViewController: UITextViewDelegate {
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
