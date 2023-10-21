//
//  Optionable.swift
//  FoodBowl
//
//  Created by COBY_PRO on 10/21/23.
//

import UIKit

protocol Optionable: UIGestureRecognizerDelegate {
}

extension Optionable where Self: UIViewController {
    func presentBlameViewController(targetId: Int, blameTarget: String) {
        let viewController = BlameViewController(targetId: targetId, blameTarget: blameTarget)
        let navigationController = UINavigationController(rootViewController: viewController)
        navigationController.modalPresentationStyle = .fullScreen
        
        DispatchQueue.main.async {
            self.present(navigationController, animated: true)
        }
    }
    
    func presentEditViewController(reviewId: Int) {
        let viewModel = UpdateReviewViewModel(reviewContent: "", images: [])
        let viewController = UpdateReviewViewController(viewModel: viewModel)
        let navigationController = UINavigationController(rootViewController: viewController)
        navigationController.modalPresentationStyle = .fullScreen
        
        DispatchQueue.main.async {
            self.present(navigationController, animated: true)
        }
    }
}
