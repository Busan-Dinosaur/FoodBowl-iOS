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
    // MARK: - life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        showModalViewController()
    }

    func showModalViewController() {
        let modalViewController = FriendFeedViewController()
        modalViewController.definesPresentationContext = true
        modalViewController.modalPresentationStyle = .overCurrentContext
        modalViewController.sheetPresentationController?.prefersGrabberVisible = true
        present(modalViewController, animated: true, completion: nil)
    }
}
