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
    private enum Size {
        static let collectionInset = UIEdgeInsets(
            top: 0,
            left: 20,
            bottom: 0,
            right: 20
        )
    }

    private var isBookMark = false

    private let categories = Category.allCases

    private var marks: [Marker]?

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

    private lazy var searchBarButton = SearchBarButton().then {
        $0.label.text = "친구들의 후기를 찾아보세요."
        let action = UIAction { [weak self] _ in
            let findStoreViewController = FindStoreViewController()
            let navigationController = UINavigationController(rootViewController: findStoreViewController)
            navigationController.modalPresentationStyle = .fullScreen
            DispatchQueue.main.async {
                self?.present(navigationController, animated: true)
            }
        }
        $0.addAction(action, for: .touchUpInside)
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
        $0.allowsMultipleSelection = true
        $0.register(CategoryCollectionViewCell.self, forCellWithReuseIdentifier: CategoryCollectionViewCell.className)
    }

    private lazy var gpsButton = UIButton().then {
        $0.backgroundColor = .mainBackground
        $0.tintColor = .mainText
        $0.makeBorderLayer(color: .grey002)
        $0.setImage(ImageLiteral.btnGps.withRenderingMode(.alwaysTemplate), for: .normal)
        $0.imageEdgeInsets = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        let action = UIAction { [weak self] _ in
            self?.findMyLocation()
        }
        $0.addAction(action, for: .touchUpInside)
    }

    private lazy var bookMarkButton = UIButton().then {
        $0.backgroundColor = .mainBackground
        $0.makeBorderLayer(color: .grey002)
        $0.setImage(ImageLiteral.btnBookmarkFill.withRenderingMode(.alwaysTemplate), for: .normal)
        $0.tintColor = .mainText
        $0.imageEdgeInsets = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        let action = UIAction { [weak self] _ in
            self?.findMyBookmarks()
        }
        $0.addAction(action, for: .touchUpInside)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        findMyLocation()
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

    override func setupLayout() {
        view.addSubviews(mapView, searchBarButton, listCollectionView, gpsButton, bookMarkButton)

        mapView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }

        searchBarButton.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide)
            $0.leading.trailing.equalToSuperview().inset(20)
            $0.height.equalTo(50)
        }

        listCollectionView.snp.makeConstraints {
            $0.top.equalTo(searchBarButton.snp.bottom).offset(10)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(40)
        }

        gpsButton.snp.makeConstraints {
            $0.trailing.equalToSuperview().inset(20)
            $0.bottom.equalTo(view.safeAreaLayoutGuide).inset(40)
            $0.height.width.equalTo(50)
        }

        bookMarkButton.snp.makeConstraints {
            $0.trailing.equalToSuperview().inset(20)
            $0.bottom.equalTo(gpsButton.snp.top).offset(-10)
            $0.height.width.equalTo(50)
        }
    }

    override func setupNavigationBar() {
        navigationController?.isNavigationBarHidden = true
    }

    private func findMyLocation() {
        guard let currentLoc = LocationManager.shared.manager.location else { return }

        mapView.setRegion(
            MKCoordinateRegion(
                center: currentLoc.coordinate,
                span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
            ),
            animated: true
        )
    }

    private func findMyBookmarks() {
        isBookMark = !isBookMark
        if isBookMark {
            bookMarkButton.tintColor = .mainPink
        } else {
            bookMarkButton.tintColor = .mainText
        }
    }

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
                    let storeFeedViewController = StoreFeedViewController()
                    storeFeedViewController.title = "틈새라면"
                    self?.navigationController?.pushViewController(storeFeedViewController, animated: true)
                }
            ),
            Marker(
                title: "홍대입구역 편의점",
                subtitle: "3개의 후기",
                coordinate: CLLocationCoordinate2D(
                    latitude: currentLoc.coordinate.latitude + 0.001,
                    longitude: currentLoc.coordinate.longitude + 0.002
                ),
                glyphImage: ImageLiteral.salad,
                handler: { [weak self] in
                    let storeFeedViewController = StoreFeedViewController()
                    storeFeedViewController.title = "틈새라면"
                    self?.navigationController?.pushViewController(storeFeedViewController, animated: true)
                }
            ),
            Marker(
                title: "홍대입구역 편의점",
                subtitle: "3개의 후기",
                coordinate: CLLocationCoordinate2D(
                    latitude: currentLoc.coordinate.latitude + 0.001,
                    longitude: currentLoc.coordinate.longitude + 0.003
                ),
                glyphImage: ImageLiteral.chinese,
                handler: { [weak self] in
                    let storeFeedViewController = StoreFeedViewController()
                    storeFeedViewController.title = "틈새라면"
                    self?.navigationController?.pushViewController(storeFeedViewController, animated: true)
                }
            ),
            Marker(
                title: "홍대입구역 편의점",
                subtitle: "3개의 후기",
                coordinate: CLLocationCoordinate2D(
                    latitude: currentLoc.coordinate.latitude + 0.001,
                    longitude: currentLoc.coordinate.longitude + 0.004
                ),
                glyphImage: ImageLiteral.japanese,
                handler: { [weak self] in
                    let storeFeedViewController = StoreFeedViewController()
                    storeFeedViewController.title = "틈새라면"
                    self?.navigationController?.pushViewController(storeFeedViewController, animated: true)
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

// MARK: - UICollectionViewDataSource, UICollectionViewDelegate

extension MapViewController: UICollectionViewDataSource, UICollectionViewDelegate {
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
