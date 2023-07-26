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
    override func viewDidLoad() {
        modalView = FriendFeedView()
        super.viewDidLoad()
    }
}
