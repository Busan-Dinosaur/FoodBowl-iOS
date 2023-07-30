//
//  UnivViewController.swift
//  FoodBowl
//
//  Created by COBY_PRO on 2023/07/18.
//

import UIKit

import SnapKit
import Then

final class UnivViewController: MapViewController {
    init() {
        super.init(nibName: nil, bundle: nil)
        self.modalView = FriendFeedView()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func configureUI() {
        super.configureUI()
        grabbarView.modalTitleLabel.text = "부산대학교 맛집"
        grabbarView.modalResultLabel.text = "4개의 맛집, 10개의 후기"
    }
}
