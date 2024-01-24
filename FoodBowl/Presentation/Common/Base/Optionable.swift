//
//  Optionable.swift
//  FoodBowl
//
//  Created by COBY_PRO on 10/21/23.
//

import UIKit

protocol Optionable: UIGestureRecognizerDelegate {
    func removeReview(reviewId: Int)
}

extension Optionable where Self: UIViewController {
    func presentReviewOptionAlert(reviewId: Int, isMyReview: Bool) {
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        if isMyReview {
            let edit = UIAlertAction(title: "수정", style: .default, handler: { _ in
                self.presentEditViewController(reviewId: reviewId)
            })
            alert.addAction(edit)
            
            let del = UIAlertAction(title: "삭제", style: .destructive, handler: { _ in
                self.makeRequestAlert(
                    title: "삭제 여부",
                    message: "정말로 삭제하시겠습니까?",
                    okAction: { _ in
                        self.removeReview(reviewId: reviewId)
                    }
                )
            })
            alert.addAction(del)
        } else {
            let report = UIAlertAction(title: "신고", style: .destructive, handler: { _ in
                self.presentBlameViewController(targetId: reviewId, blameTarget: "REVIEW")
            })
            alert.addAction(report)
        }
        
        let cancel = UIAlertAction(title: "취소", style: .cancel, handler: nil)
        alert.addAction(cancel)
        
        DispatchQueue.main.async { [weak self] in
            self?.present(alert, animated: true, completion: nil)
        }
    }
    
    func presentMemberOptionAlert(memberId: Int) {
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)

        let report = UIAlertAction(title: "신고", style: .destructive, handler: { _ in
            self.presentBlameViewController(targetId: memberId, blameTarget: "MEMBER")
        })
        let cancel = UIAlertAction(title: "취소", style: .cancel, handler: nil)

        alert.addAction(cancel)
        alert.addAction(report)

        DispatchQueue.main.async { [weak self] in
            self?.present(alert, animated: true, completion: nil)
        }
    }
    
    func presentBlameViewController(targetId: Int, blameTarget: String) {
        let repository = BlameRepositoryImpl()
        let usecase = BlameUsecaseImpl(repository: repository)
        let viewModel = BlameViewModel(usecase: usecase, targetId: targetId, blameTarget: blameTarget)
        let viewController = BlameViewController(viewModel: viewModel)
        let navigationController = UINavigationController(rootViewController: viewController)
        navigationController.modalPresentationStyle = .fullScreen
        
        DispatchQueue.main.async { [weak self] in
            self?.present(navigationController, animated: true)
        }
    }
    
    func presentEditViewController(reviewId: Int) {
//        let repository = UpdateReviewRepositoryImpl()
//        let usecase = UpdateReviewUsecaseImpl(repository: repository)
//        let viewModel = UpdateReviewViewModel(usecase: usecase)
//        let viewController = UpdateReviewViewController(viewModel: viewModel)
//        let navigationController = UINavigationController(rootViewController: viewController)
//        navigationController.modalPresentationStyle = .fullScreen
//        
//        DispatchQueue.main.async { [weak self] in
//            self?.present(navigationController, animated: true)
//        }
    }
    
    func removeReview(reviewId: Int) {}
}
