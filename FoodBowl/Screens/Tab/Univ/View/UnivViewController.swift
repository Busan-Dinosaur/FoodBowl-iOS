//
//  UnivViewController.swift
//  FoodBowl
//
//  Created by COBY_PRO on 2023/07/18.
//

import MapKit
import UIKit

import SnapKit
import Then

final class UnivViewController: MapViewController {
    private var viewModel = UnivViewModel()

    private var univ = UserDefaultsManager.currentUniv

    private lazy var univTitleButton = UnivTitleButton().then {
        let action = UIAction { [weak self] _ in
            let searchUnivViewController = SearchUnivViewController()
            searchUnivViewController.delegate = self
            let navigationController = UINavigationController(rootViewController: searchUnivViewController)
            DispatchQueue.main.async {
                self?.present(navigationController, animated: true)
            }
        }
        $0.downButton.addAction(action, for: .touchUpInside)
        $0.frame = CGRect(x: 0, y: 0, width: 300, height: 45)
        $0.label.text = "대학가"
    }

    override func setupNavigationBar() {
        super.setupNavigationBar()
        let leftOffsetUnivTitleButton = removeBarButtonItemOffset(with: univTitleButton, offsetX: 10)
        let univTitleButton = makeBarButtonItem(with: leftOffsetUnivTitleButton)
        let plusButton = makeBarButtonItem(with: plusButton)
        navigationItem.leftBarButtonItem = univTitleButton
        navigationItem.rightBarButtonItem = plusButton
    }

    override func removeBarButtonItemOffset(with button: UIButton, offsetX: CGFloat = 0, offsetY: CGFloat = 0) -> UIView {
        let offsetView = UIView(frame: CGRect(x: 0, y: 0, width: 300, height: 45))
        offsetView.bounds = offsetView.bounds.offsetBy(dx: offsetX, dy: offsetY)
        offsetView.addSubview(button)
        return offsetView
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        univTitleButton.label.text = univ?.name ?? "대학가"
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
        feedListView.listCollectionView.reloadData()
    }

    private func setupStores() async {
        guard let location = customLocation else { return }
        stores = await viewModel.getStores(location: location)
        grabbarView.modalResultLabel.text = "\(stores.count)개의 맛집"
        setMarkers()
    }

    override func presentBlameViewController() {
        let createReviewController = BlameViewController(targetId: 123, blameTarget: "Member")
        let navigationController = UINavigationController(rootViewController: createReviewController)
        DispatchQueue.main.async {
            self.present(navigationController, animated: true)
        }
    }

    override func currentLocation() {
        guard let univ = UserDefaultsManager.currentUniv else { return }

        mapView.setRegion(
            MKCoordinateRegion(
                center: CLLocationCoordinate2D(latitude: univ.y, longitude: univ.x),
                span: MKCoordinateSpan(latitudeDelta: 0.02, longitudeDelta: 0.02)
            ),
            animated: true
        )
    }
}

extension UnivViewController: SearchUnivViewControllerDelegate {
    func setUniv(univ: School) {
        self.univ = univ
        univTitleButton.label.text = univ.name
        UserDefaultsManager.currentUniv = univ
        currentLocation()
        loadData()
    }
}
