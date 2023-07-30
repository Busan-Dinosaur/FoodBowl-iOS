//
//  BookmarkViewController.swift
//  FoodBowl
//
//  Created by COBY_PRO on 2023/07/18.
//

import UIKit

import SnapKit
import Then

final class BookmarkViewController: MapViewController {
    init() {
        super.init(nibName: nil, bundle: nil)
        self.modalView = BookmarkListView()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
