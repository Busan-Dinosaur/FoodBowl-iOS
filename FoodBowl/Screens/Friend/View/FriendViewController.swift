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
//        showModalViewController()
    }

    func showModalViewController() {
        let modalViewController = FriendFeedViewController()

        modalViewController.isModalInPresentation = true
        if let sheet = modalViewController.sheetPresentationController {
            sheet.detents = [
                .custom(resolver: { context in
                    0.1 * context.maximumDetentValue
                }), .medium()
            ]
            sheet.largestUndimmedDetentIdentifier = .medium
            sheet.prefersGrabberVisible = true
            sheet.presentingViewController.modalPresentationStyle = .overCurrentContext
        }

        present(modalViewController, animated: true, completion: nil)
    }
}
