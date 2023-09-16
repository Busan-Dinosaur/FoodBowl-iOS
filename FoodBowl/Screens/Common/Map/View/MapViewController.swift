//
//  MapViewController.swift
//  FoodBowl
//
//  Created by COBY_PRO on 2023/01/10.
//

import CoreLocation
import MapKit
import MessageUI
import UIKit

import SnapKit
import Then

class MapViewController: BaseViewController {
    // 임시 마커 데이터
    private var marks: [Marker]?

    lazy var topPadding: CGFloat = {
        let scenes = UIApplication.shared.connectedScenes
        let windowScene = scenes.first as? UIWindowScene
        let window = windowScene?.windows.first
        let topPadding = window?.safeAreaInsets.top ?? 0
        return topPadding
    }()

    let modalMinHeight: CGFloat = 40
    let modalMidHeight: CGFloat = UIScreen.main.bounds.height / 2 - 100
    lazy var tabBarHeight: CGFloat = tabBarController?.tabBar.frame.height ?? 0
    lazy var navBarHeight: CGFloat = navigationController?.navigationBar.frame.height ?? 0
    lazy var modalMaxHeight: CGFloat = UIScreen.main.bounds.height - topPadding - navBarHeight - 120
    var currentModalHeight: CGFloat = 0

    var categoryListHeight: CGFloat = 40

    private var panGesture = UIPanGestureRecognizer()

    // MARK: - propert
    lazy var mapView = MKMapView().then {
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

    lazy var trakingButton = MKUserTrackingButton(mapView: mapView).then {
        $0.layer.backgroundColor = UIColor.mainBackground.cgColor
        $0.layer.borderColor = UIColor.grey002.cgColor
        $0.layer.borderWidth = 1
        $0.layer.cornerRadius = 10
        $0.layer.masksToBounds = true
        $0.tintColor = UIColor.mainPink
    }

    lazy var bookmarkButton = BookmarkMapButton().then {
        $0.layer.backgroundColor = UIColor.mainBackground.cgColor
        $0.layer.borderColor = UIColor.grey002.cgColor
        $0.layer.borderWidth = 1
        $0.layer.cornerRadius = 10
        $0.layer.masksToBounds = true
//        $0.tintColor = UIColor.mainPink
        let action = UIAction { [weak self] _ in
            self?.tappedBookMarkButton()
        }
        $0.addAction(action, for: .touchUpInside)
    }

    let categoryListView = CategoryListView()

    let grabbarView = GrabbarView()

    lazy var modalView: ModalView = .init()

    // MARK: - life cycle
    override func viewDidLoad() {
        setupLayout()
        configureUI()
        setupNavigationBar()
        currentLocation()
        setMarkers()
    }

    override func setupLayout() {
        view.addSubviews(mapView, categoryListView, trakingButton, bookmarkButton, grabbarView, modalView)

        mapView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide)
            $0.leading.trailing.bottom.equalToSuperview()
        }

        categoryListView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(40)
        }

        trakingButton.snp.makeConstraints {
            $0.trailing.equalToSuperview().inset(BaseSize.horizantalPadding)
            $0.top.equalTo(categoryListView.snp.bottom).offset(20)
            $0.height.width.equalTo(40)
        }

        bookmarkButton.snp.makeConstraints {
            $0.trailing.equalToSuperview().inset(BaseSize.horizantalPadding)
            $0.top.equalTo(trakingButton.snp.bottom).offset(8)
            $0.height.width.equalTo(40)
        }

        grabbarView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(80)
        }

        modalView.snp.makeConstraints {
            $0.top.equalTo(grabbarView.snp.bottom)
            $0.leading.trailing.bottom.equalToSuperview()
            $0.height.equalTo(modalMidHeight)
        }
    }

    override func configureUI() {
        super.configureUI()
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePan(_:)))
        grabbarView.isUserInteractionEnabled = true
        grabbarView.addGestureRecognizer(panGesture)
        currentModalHeight = modalMidHeight
        bookmarkButton.isHidden = true
    }

    func currentLocation() {
        guard let currentLoc = LocationManager.shared.manager.location else { return }

        mapView.setRegion(
            MKCoordinateRegion(
                center: currentLoc.coordinate,
                span: MKCoordinateSpan(latitudeDelta: 0.02, longitudeDelta: 0.02)
            ),
            animated: true
        )
    }

    @objc
    func handlePan(_ gesture: UIPanGestureRecognizer) {
        guard gesture.view != nil else { return }
        let translation = gesture.translation(in: gesture.view?.superview)
        var newModalHeight = currentModalHeight - translation.y
        if newModalHeight <= modalMinHeight {
            newModalHeight = modalMinHeight
            modalMinState()
        } else if newModalHeight >= modalMaxHeight {
            newModalHeight = modalMaxHeight
            modalMaxState()
        } else {
            modalMidState()
        }

        modalView.snp.remakeConstraints {
            $0.top.equalTo(grabbarView.snp.bottom)
            $0.leading.trailing.bottom.equalToSuperview()
            $0.height.equalTo(newModalHeight)
        }

        if gesture.state == .ended {
            switch newModalHeight {
            case let height where height - modalMinHeight < modalMidHeight - height:
                currentModalHeight = modalMinHeight
                modalMinState()
            case let height where height - modalMidHeight < modalMaxHeight - height:
                currentModalHeight = modalMidHeight
                modalMidState()
            default:
                currentModalHeight = modalMaxHeight
                modalMaxState()
            }

            UIView.animate(
                withDuration: 0.5,
                delay: 0,
                usingSpringWithDamping: 0.5,
                initialSpringVelocity: 0.5,
                options: .curveEaseInOut,
                animations: {
                    self.modalView.snp.updateConstraints {
                        $0.top.equalTo(self.grabbarView.snp.bottom)
                        $0.leading.trailing.bottom.equalToSuperview()
                        $0.height.equalTo(self.currentModalHeight)
                    }
                    self.modalView.superview?.layoutIfNeeded()
                }
            )
        }
    }

    func modalMinState() {
        grabbarView.showResult()
        modalView.listCollectionView.isHidden = true
        modalView.borderLineView.isHidden = true
        tabBarController?.tabBar.frame.origin = CGPoint(x: 0, y: UIScreen.main.bounds.maxY)
    }

    func modalMidState() {
        grabbarView.showContent()
        modalView.listCollectionView.isHidden = false
        modalView.borderLineView.isHidden = false
        tabBarController?.tabBar.frame.origin = CGPoint(x: 0, y: UIScreen.main.bounds.maxY - tabBarHeight)
        grabbarView.layer.cornerRadius = 15
    }

    func modalMaxState() {
        grabbarView.layer.cornerRadius = 0
    }

    func tappedBookMarkButton() {
        bookmarkButton.isSelected.toggle()
    }

    // 임시 데이터
    func setMarkers() {
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
