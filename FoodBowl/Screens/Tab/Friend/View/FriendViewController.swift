//
//  FriendViewController.swift
//  FoodBowl
//
//  Created by COBY_PRO on 2023/07/18.
//

import UIKit

import SnapKit
import Then

final class FriendViewController: MapViewController {
    let logoLabel = PaddingLabel().then {
        $0.font = .font(.regular, ofSize: 22)
        $0.textColor = .mainText
        $0.text = "친구들"
        $0.padding = UIEdgeInsets(top: 0, left: 4, bottom: 0, right: 0)
        $0.frame = CGRect(x: 0, y: 0, width: 150, height: 0)
    }

    init() {
        super.init(nibName: nil, bundle: nil)
        self.modalView = FeedListView()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func configureUI() {
        super.configureUI()
        bookmarkButton.isHidden = false
        grabbarView.modalResultLabel.text = "4개의 맛집"
    }

    override func setupNavigationBar() {
        super.setupNavigationBar()
        let logoLabel = makeBarButtonItem(with: logoLabel)
        let plusButton = makeBarButtonItem(with: plusButton)
        navigationItem.leftBarButtonItem = logoLabel
        navigationItem.rightBarButtonItem = plusButton
    }
}