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

    let targetId: Int
    let blameTarget: String

    private let textViewPlaceHolder = "100자 이내"

    init(targetId: Int, blameTarget: String) {
        self.targetId = targetId
        self.blameTarget = blameTarget
        super.init(nibName: nil, bundle: nil)
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

    lazy var commentTextView = UITextView().then {
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
            commentTextView,
            completeButton
        )

        commentTextView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide)
            $0.leading.trailing.equalToSuperview().inset(BaseSize.horizantalPadding)
            $0.height.equalTo(100)
        }

        completeButton.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(BaseSize.horizantalPadding)
            $0.bottom.equalToSuperview().inset(BaseSize.bottomPadding)
            $0.height.equalTo(60)
        }
    }

    override func setupNavigationBar() {
        let blameGuideLabel = makeBarButtonItem(with: blameGuideLabel)
        navigationItem.leftBarButtonItem = blameGuideLabel
    }

    private func showAlert(message: String) {
        let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        let cancel = UIAlertAction(title: "닫기", style: .cancel, handler: nil)
        alert.addAction(cancel)

        present(alert, animated: true, completion: nil)
    }

    private func tappedCompleteButton() {
        if commentTextView.text == "" {
            showAlert(message: "내용을 작성하지 않았습니다.")
            return
        }

        async {
            await createBlame()
        }
    }

    private func createBlame() async {
        let providerService = MoyaProvider<ServiceAPI>()

        let response = await providerService.request(
            .createBlame(
                request: CreateBlameRequest(
                    targetId: targetId,
                    blameTarget: blameTarget,
                    description: commentTextView.text
                )
            )
        )
        switch response {
        case .success:
            print("Success to create blame")
        case .failure(let err):
            print(err.localizedDescription)
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