//
//  MapViewController.swift
//  FoodBowl
//
//  Created by COBY_PRO on 2023/01/10.
//

import CoreLocation
import MapKit
import UIKit

import SnapKit
import Then

class MapViewController: UIViewController {
    // 임시 마커 데이터
    private var marks: [Marker]?

    // MARK: - property
    private lazy var mapView = MKMapView().then {
        $0.delegate = self
        $0.mapType = MKMapType.standard
        $0.showsUserLocation = true
        $0.setUserTrackingMode(.follow, animated: true)
        $0.isZoomEnabled = true
        $0.showsCompass = false
        $0.register(
            MapItemAnnotationView.self,
            forAnnotationViewWithReuseIdentifier: MKMapViewDefaultAnnotationViewReuseIdentifier
        )
        $0.register(
            ClusterAnnotationView.self,
            forAnnotationViewWithReuseIdentifier: MKMapViewDefaultClusterAnnotationViewReuseIdentifier
        )
    }

    private lazy var trakingButton = MKUserTrackingButton(mapView: mapView).then {
        $0.layer.backgroundColor = UIColor.mainBackground.cgColor
        $0.layer.borderColor = UIColor.grey002.cgColor
        $0.layer.borderWidth = 1
        $0.layer.cornerRadius = 10
        $0.layer.masksToBounds = true
        $0.tintColor = UIColor.mainPink
    }

    private lazy var mapHeaderView = MapHeaderView().then {
        let findAction = UIAction { [weak self] _ in
            let findStoreViewController = FindViewController()
            let navigationController = UINavigationController(rootViewController: FindViewController())
            navigationController.modalPresentationStyle = .fullScreen
            DispatchQueue.main.async {
                self?.present(navigationController, animated: true)
            }
        }
        let plusAction = UIAction { [weak self] _ in
            let newFeedViewController = NewFeedViewController()
            let navigationController = UINavigationController(rootViewController: newFeedViewController)
            navigationController.modalPresentationStyle = .fullScreen
            DispatchQueue.main.async {
                self?.present(navigationController, animated: true)
            }
        }
        $0.searchBarButton.addAction(findAction, for: .touchUpInside)
        $0.plusButton.addAction(plusAction, for: .touchUpInside)

        let scenes = UIApplication.shared.connectedScenes
        let windowScene = scenes.first as? UIWindowScene
        let window = windowScene?.windows.first
        let topPadding = window?.safeAreaInsets.top ?? 0
        let headerHeight = topPadding + 90

        $0.snp.makeConstraints {
            $0.height.equalTo(headerHeight)
        }
    }

    // MARK: - life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupLayout()
        setupNavigationBar()
        currentLocation()
        setMarkers()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.isNavigationBarHidden = true
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.isNavigationBarHidden = false
    }

    func setupLayout() {
        view.addSubviews(mapView, mapHeaderView, trakingButton)

        mapView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }

        mapHeaderView.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview()
        }

        trakingButton.snp.makeConstraints {
            $0.trailing.equalToSuperview().inset(BaseSize.horizantalPadding)
            $0.bottom.equalTo(view.safeAreaLayoutGuide).inset(40)
            $0.height.width.equalTo(40)
        }
    }

    func setupNavigationBar() {
        navigationController?.isNavigationBarHidden = true
    }

    private func currentLocation() {
        guard let currentLoc = LocationManager.shared.manager.location else { return }

        mapView.setRegion(
            MKCoordinateRegion(
                center: currentLoc.coordinate,
                span: MKCoordinateSpan(latitudeDelta: 0.02, longitudeDelta: 0.02)
            ),
            animated: true
        )
    }

    // 임시 데이터
    private func setMarkers() {
        guard let currentLoc = LocationManager.shared.manager.location else { return }

        marks = [
            Marker(
                title: "홍대입구역 편의점",
                subtitle: "3개의 후기",
                coordinate: CLLocationCoordinate2D(
                    latitude: currentLoc.coordinate.latitude + 0.001,
                    longitude: currentLoc.coordinate.longitude + 0.001
                ),
                glyphImage: ImageLiteral.korean,
                handler: { [weak self] in
                    let storeDetailViewController = StoreDetailViewController()
                    storeDetailViewController.title = "틈새라면"
                    self?.navigationController?.pushViewController(storeDetailViewController, animated: true)
                }
            ),
            Marker(
                title: "홍대입구역 서점",
                subtitle: "123개의 후기",
                coordinate: CLLocationCoordinate2D(
                    latitude: currentLoc.coordinate.latitude + 0.001,
                    longitude: currentLoc.coordinate.longitude + 0.002
                ),
                glyphImage: ImageLiteral.salad,
                handler: { [weak self] in
                    let storeDetailViewController = StoreDetailViewController()
                    storeDetailViewController.title = "틈새라면"
                    self?.navigationController?.pushViewController(storeDetailViewController, animated: true)
                }
            )
        ]

        marks?.forEach { mark in
            mapView.addAnnotation(mark)
        }
    }
}

extension MapViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        guard view is ClusterAnnotationView else { return }

        let currentSpan = mapView.region.span
        let zoomSpan = MKCoordinateSpan(
            latitudeDelta: currentSpan.latitudeDelta / 3.0,
            longitudeDelta: currentSpan.longitudeDelta / 3.0
        )
        let zoomCoordinate = view.annotation?.coordinate ?? mapView.region.center
        let zoomed = MKCoordinateRegion(center: zoomCoordinate, span: zoomSpan)
        mapView.setRegion(zoomed, animated: true)
    }
}
