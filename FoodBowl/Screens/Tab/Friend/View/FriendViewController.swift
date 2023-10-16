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
    private var viewModel = FriendViewModel()

    let logoLabel = PaddingLabel().then {
        $0.font = .font(.regular, ofSize: 22)
        $0.textColor = .mainTextColor
        $0.text = "친구들"
        $0.padding = UIEdgeInsets(top: 0, left: 4, bottom: 0, right: 0)
        $0.frame = CGRect(x: 0, y: 0, width: 150, height: 0)
    }

    override func configureUI() {
        super.configureUI()
        bookmarkButton.isHidden = false
        feedListView.loadData = {
            Task {
                await self.setupReviews()
            }
        }
        feedListView.reloadData = {
            Task {
                print("추가 데이터")
            }
        }
    }

    override func setupNavigationBar() {
        super.setupNavigationBar()
        let logoLabel = makeBarButtonItem(with: logoLabel)
        let plusButton = makeBarButtonItem(with: plusButton)
        navigationItem.leftBarButtonItem = logoLabel
        navigationItem.rightBarButtonItem = plusButton
    }

    override func loadData() {
        Task {
            await setupReviews()
            await setupStores()
        }
    }

    private func setupReviews() async {
        guard let location = customLocation else { return }
        feedListView.reviews = await viewModel.getReviews(location: location)
    }

    private func setupStores() async {
        guard let location = customLocation else { return }
        stores = await viewModel.getStores(location: location)

        DispatchQueue.main.async {
            self.grabbarView.modalResultLabel.text = "\(self.stores.count.prettyNumber)개의 맛집"
            self.setMarkers()
        }
    }
}
