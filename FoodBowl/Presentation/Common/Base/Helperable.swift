//
//  Helperable.swift
//  FoodBowl
//
//  Created by Coby on 1/25/24.
//

import UIKit

protocol Helperable {
    func presentProfileViewController(id: Int)
    func presentUpdateProfileViewController()
    func presentStoreDetailViewController(id: Int)
    func presentReviewDetailViewController(id: Int)
    func presentCreateReviewViewController()
    func presentUpdateReviewViewController(id: Int)
    func presentSearchStoreViewController()
    func presentFollowerViewController(id: Int, isOwn: Bool)
    func presentFollowingViewController(id: Int)
    func presentShowWebViewController(url: String)
}

extension Helperable where Self: UIViewController {
    func presentProfileViewController(id: Int) {
        let repository = ProfileRepositoryImpl()
        let usecase = ProfileUsecaseImpl(repository: repository)
        let viewModel = ProfileViewModel(
            usecase: usecase,
            memberId: id
        )
        let viewController = ProfileViewController(viewModel: viewModel)
        self.navigationController?.pushViewController(viewController, animated: true)
    }
    
    func presentUpdateProfileViewController() {
        let repository = UpdateProfileRepositoryImpl()
        let usecase = UpdateProfileUsecaseImpl(repository: repository)
        let viewModel = UpdateProfileViewModel(usecase: usecase)
        let viewController = UpdateProfileViewController(viewModel: viewModel)
        self.navigationController?.pushViewController(viewController, animated: true)
    }
    
    func presentStoreDetailViewController(id: Int) {
        let repository = StoreDetailRepositoryImpl()
        let usecase = StoreDetailUsecaseImpl(repository: repository)
        let viewModel = StoreDetailViewModel(
            usecase: usecase,
            storeId: id
        )
        let viewController = StoreDetailViewController(viewModel: viewModel)
        self.navigationController?.pushViewController(viewController, animated: true)
    }
    
    func presentReviewDetailViewController(id: Int) {
        let repository = ReviewDetailRepositoryImpl()
        let usecase = ReviewDetailUsecaseImpl(repository: repository)
        let viewModel = ReviewDetailViewModel(
            usecase: usecase,
            reviewId: id
        )
        let viewController = ReviewDetailViewController(viewModel: viewModel)
        self.navigationController?.pushViewController(viewController, animated: true)
    }
    
    func presentCreateReviewViewController() {
        let repository = CreateReviewRepositoryImpl()
        let usecase = CreateReviewUsecaseImpl(repository: repository)
        let viewModel = CreateReviewViewModel(usecase: usecase)
        let viewController = CreateReviewViewController(viewModel: viewModel)
        let navigationController = UINavigationController(rootViewController: viewController)
        navigationController.modalPresentationStyle = .fullScreen
        self.present(navigationController, animated: true)
    }
    
    func presentUpdateReviewViewController(id: Int) {
    }
    
    func presentSearchStoreViewController() {
        let repository = CreateReviewRepositoryImpl()
        let usecase = CreateReviewUsecaseImpl(repository: repository)
        let viewModel = SearchStoreViewModel(usecase: usecase)
        let viewController = SearchStoreViewController(viewModel: viewModel)
        viewController.delegate = self as? any SearchStoreViewControllerDelegate
        self.navigationController?.pushViewController(viewController, animated: true)
    }
    
    func presentFollowerViewController(id: Int, isOwn: Bool) {
        let repository = FollowRepositoryImpl()
        let usecase = FollowUsecaseImpl(repository: repository)
        let viewModel = FollowerViewModel(
            usecase: usecase,
            memberId: id,
            isOwn: isOwn
        )
        let viewController = FollowerViewController(viewModel: viewModel)
        self.navigationController?.pushViewController(viewController, animated: true)
    }
    
    func presentFollowingViewController(id: Int) {
        let repository = FollowRepositoryImpl()
        let usecase = FollowUsecaseImpl(repository: repository)
        let viewModel = FollowingViewModel(
            usecase: usecase,
            memberId: id
        )
        let viewController = FollowingViewController(viewModel: viewModel)
        self.navigationController?.pushViewController(viewController, animated: true)
    }
    
    func presentShowWebViewController(url: String) {
        let showWebViewController = ShowWebViewController(url: url)
        let navigationController = UINavigationController(rootViewController: showWebViewController)
        self.navigationController?.present(navigationController, animated: true)
    }
}
