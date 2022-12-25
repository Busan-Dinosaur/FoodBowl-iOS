//
//  CommentView.swift
//  FoodBowl
//
//  Created by COBY_PRO on 2022/12/26.
//

import UIKit

import SnapKit
import Then

final class CommentView: UIView {
    // MARK: - property

    let commentDateLabel = UILabel().then {
        $0.textColor = UIColor(hex: "#494949")
        $0.font = .preferredFont(forTextStyle: .caption2, weight: .light)
        $0.text = "2022년 12월 25일"
    }

    let commentLabel = UILabel().then {
        $0.font = UIFont.preferredFont(forTextStyle: .subheadline, weight: .light)
        $0.numberOfLines = 0
        $0.textColor = .black
        $0.text = """
        이번에 학교 앞에 새로 생겼길래 가봤는데 너무 맛있었어요.
        여기서 파는 라면 맛이 일품이에요.
        맛잘알 제가 보장하는 맛입니다! 미쳤어요...!
        차슈 라멘이 8000원인데, 이 돈 주고 먹을만 합니다.
        """
    }

    // MARK: - init

    override init(frame: CGRect) {
        super.init(frame: frame)
        render()
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func render() {
        addSubviews(commentDateLabel, commentLabel)

        commentDateLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(16)
            $0.leading.equalToSuperview().inset(20)
        }

        commentLabel.snp.makeConstraints {
            $0.top.equalTo(commentDateLabel.snp.bottom).offset(10)
            $0.leading.equalToSuperview().inset(20)
        }
    }
}
