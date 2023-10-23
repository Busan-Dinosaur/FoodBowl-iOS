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
    private let viewModel = FriendViewModel()

    private let logoLabel = PaddingLabel().then {
        $0.font = .font(.regular, ofSize: 22)
        $0.textColor = .mainTextColor
        $0.text = "친구들"
        $0.padding = UIEdgeInsets(top: 0, left: 4, bottom: 0, right: 0)
        $0.frame = CGRect(x: 0, y: 0, width: 150, height: 0)
    }

    override func configureUI() {
        super.configureUI()
        bookmarkButton.isHidden = false
    }

    private func setupNavigationBar() {
        let logoLabel = makeBarButtonItem(with: logoLabel)
        let plusButton = makeBarButtonItem(with: plusButton)
        navigationItem.leftBarButtonItem = logoLabel
        navigationItem.rightBarButtonItem = plusButton
    }

    override func loadReviews() async -> [Review] {
        guard let location = customLocation else { return [] }
        if bookmarkButton.isSelected {
            return await viewModel.getReviewsByBookmark(location: location)
        } else {
            return await viewModel.getReviews(location: location)
        }
    }

    override func loadStores() async -> [Store] {
        guard let location = customLocation else { return [] }
        if bookmarkButton.isSelected {
            return await viewModel.getStoresByBookmark(location: location)
        } else {
            return await viewModel.getStores(location: location)
        }
    }

    override func reloadReviews() async -> [Review] {
        if let location = customLocation, let lastReviewId = viewModel.lastReviewId,
           let currentpageSize = viewModel.currentpageSize, currentpageSize >= viewModel.pageSize {
            if bookmarkButton.isSelected {
                return await viewModel.getReviewsByBookmark(location: location, lastReviewId: lastReviewId)
            } else {
                return await viewModel.getReviews(location: location, lastReviewId: lastReviewId)
            }
        }
        return []
    }
}
