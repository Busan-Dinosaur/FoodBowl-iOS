//
//  SetPhotoViewController.swift
//  FoodBowl
//
//  Created by COBY_PRO on 2022/12/23.
//

import UIKit

import SnapKit
import Then

final class SetPhotoViewController: BaseViewController {
    // MARK: - property

    private let guideLabel = UILabel().then {
        $0.text = "음식 사진들을 등록해주세요."
        $0.font = UIFont.preferredFont(forTextStyle: .title3, weight: .medium)
    }

    // MARK: - life cycle

    override func render() {
        view.addSubviews(guideLabel)

        guideLabel.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top).inset(20)
            $0.leading.equalToSuperview().inset(20)
        }
    }
}
