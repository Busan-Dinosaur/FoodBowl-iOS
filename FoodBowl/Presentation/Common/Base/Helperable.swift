//
//  Helperable.swift
//  FoodBowl
//
//  Created by Coby on 1/25/24.
//

import UIKit

protocol Helperable {
    func presentProfileViewController(id: Int)
    func presentStoreDetailViewController(id: Int)
    func presentReviewDetailViewController(id: Int)
    func presentCreateReviewViewController()
    func presentSearchStoreViewController()
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
    
    func presentSearchStoreViewController() {
        let repository = CreateReviewRepositoryImpl()
        let usecase = CreateReviewUsecaseImpl(repository: repository)
        let viewModel = SearchStoreViewModel(usecase: usecase)
        let viewController = SearchStoreViewController(viewModel: viewModel)
        viewController.delegate = self as? any SearchStoreViewControllerDelegate
        self.navigationController?.pushViewController(viewController, animated: true)
    }
    
    func presentShowWebViewController(url: String) {
        let showWebViewController = ShowWebViewController(url: url)
        let navigationController = UINavigationController(rootViewController: showWebViewController)
        self.navigationController?.present(navigationController, animated: true)
    }
}
