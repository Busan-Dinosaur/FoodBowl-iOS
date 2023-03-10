//
//  UserMapViewController.swift
//  FoodBowl
//
//  Created by COBY_PRO on 2023/01/18.
//

import UIKit

import CoreLocation
import MapKit
import SnapKit
import Then

final class UserMapViewController: BaseViewController, MKMapViewDelegate {
    private enum Size {
        static let collectionInset = UIEdgeInsets(
            top: 0,
            left: 20,
            bottom: 0,
            right: 20
        )
    }

    private let categories = Category.allCases

    private lazy var locationManager: CLLocationManager = {
        let manager = CLLocationManager()
        manager.desiredAccuracy = kCLLocationAccuracyBest
        manager.startUpdatingLocation()
        manager.delegate = self
        return manager
    }()

    private lazy var mapView = MKMapView().then {
        $0.delegate = self
        $0.mapType = MKMapType.standard
        $0.showsUserLocation = true
        $0.setUserTrackingMode(.follow, animated: true)
        $0.isZoomEnabled = true
        $0.showsCompass = false
    }

    private let collectionViewFlowLayout = UICollectionViewFlowLayout().then {
        $0.scrollDirection = .horizontal
        $0.sectionInset = Size.collectionInset
        $0.minimumLineSpacing = 4
        $0.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
    }

    private lazy var listCollectionView = UICollectionView(frame: .zero, collectionViewLayout: collectionViewFlowLayout).then {
        $0.backgroundColor = .clear
        $0.dataSource = self
        $0.delegate = self
        $0.showsHorizontalScrollIndicator = false
        $0.register(CategoryCollectionViewCell.self, forCellWithReuseIdentifier: CategoryCollectionViewCell.className)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        findMyLocation()
    }

    override func viewWillDisappear(_: Bool) {
        locationManager.stopUpdatingLocation()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        let indexPath = IndexPath(item: 0, section: 0)
        listCollectionView.selectItem(
            at: indexPath,
            animated: false,
            scrollPosition: UICollectionView.ScrollPosition(rawValue: 0)
        )
        collectionView(listCollectionView, didSelectItemAt: indexPath)
    }

    override func setupLayout() {
        view.addSubviews(mapView, listCollectionView)

        mapView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }

        listCollectionView.snp.makeConstraints {
            $0.top.equalToSuperview().inset(10)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(40)
        }
    }

    override func setupNavigationBar() {
        super.setupNavigationBar()
        title = "????????????"
    }

    private func getLocationUsagePermission() {
        locationManager.requestWhenInUseAuthorization()
    }

    private func findMyLocation() {
        guard let currentLocation = locationManager.location else {
            getLocationUsagePermission()
            return
        }

        mapView.setRegion(
            MKCoordinateRegion(
                center: currentLocation.coordinate,
                span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
            ),
            animated: true
        )
    }
}

extension UserMapViewController: CLLocationManagerDelegate {
    func locationManager(_: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .authorizedAlways, .authorizedWhenInUse:
            print("GPS ?????? ?????????")
        case .restricted, .notDetermined:
            print("GPS ?????? ???????????? ??????")
            DispatchQueue.main.async {
                self.getLocationUsagePermission()
            }
        case .denied:
            print("GPS ?????? ?????? ?????????")
            DispatchQueue.main.async {
                self.getLocationUsagePermission()
            }
        default:
            print("GPS: Default")
        }
    }
}

// MARK: - UICollectionViewDataSource, UICollectionViewDelegate

extension UserMapViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_: UICollectionView, numberOfItemsInSection _: Int) -> Int {
        return categories.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: CategoryCollectionViewCell.className,
            for: indexPath
        ) as? CategoryCollectionViewCell else {
            return UICollectionViewCell()
        }

        cell.layer.cornerRadius = 20
        cell.categoryLabel.text = categories[indexPath.item].rawValue

        return cell
    }

    func collectionView(_: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print(categories[indexPath.item].rawValue)
    }
}
