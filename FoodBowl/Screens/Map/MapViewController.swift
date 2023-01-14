//
//  MapViewController.swift
//  FoodBowl
//
//  Created by COBY_PRO on 2023/01/10.
//

import UIKit

import CoreLocation
import MapKit
import SnapKit
import Then

final class MapViewController: BaseViewController {
    lazy var locationManager: CLLocationManager = {
        let manager = CLLocationManager()
        manager.desiredAccuracy = kCLLocationAccuracyBest
        manager.startUpdatingLocation()
        manager.delegate = self
        return manager
    }()

    let mapView = MKMapView()

    lazy var searchBarButton = SearchBarButton().then {
        $0.label.text = "가게 이름을 검색해주세요."
        let action = UIAction { [weak self] _ in
        }
        $0.addAction(action, for: .touchUpInside)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        getLocationUsagePermission()

        mapView.mapType = MKMapType.standard
        mapView.showsUserLocation = true
        mapView.setUserTrackingMode(.follow, animated: true)
        mapView.isZoomEnabled = true
    }

    func getLocationUsagePermission() {
        locationManager.requestWhenInUseAuthorization()
    }

    override func viewWillDisappear(_: Bool) {
        locationManager.stopUpdatingLocation()
    }

    override func render() {
        view.addSubviews(mapView, searchBarButton)

        mapView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }

        searchBarButton.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide)
            $0.leading.trailing.equalToSuperview().inset(20)
            $0.height.equalTo(50)
        }
    }

    override func setupNavigationBar() {
        navigationController?.isNavigationBarHidden = true
    }
}

extension MapViewController: CLLocationManagerDelegate {
    func locationManager(_: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .authorizedAlways, .authorizedWhenInUse:
            print("GPS 권한 설정됨")
        case .restricted, .notDetermined:
            print("GPS 권한 설정되지 않음")
            DispatchQueue.main.async {
                self.getLocationUsagePermission()
            }
        case .denied:
            print("GPS 권한 요청 거부됨")
            DispatchQueue.main.async {
                self.getLocationUsagePermission()
            }
        default:
            print("GPS: Default")
        }
    }
}
