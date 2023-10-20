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
    var customLocation: CustomLocation?
    var currentLoction: CLLocationCoordinate2D?

    var stores = [Store]()

    var markers = [Marker]()

    let modalMinHeight: CGFloat = 40
    let modalMidHeight: CGFloat = UIScreen.main.bounds.height / 2 - 100
    lazy var tabBarHeight: CGFloat = tabBarController?.tabBar.frame.height ?? 0
    lazy var navBarHeight: CGFloat = navigationController?.navigationBar.frame.height ?? 0
    lazy var modalMaxHeight: CGFloat = UIScreen.main.bounds.height - BaseSize.topAreaPadding - navBarHeight - 120
    var currentModalHeight: CGFloat = 0
    var categoryListHeight: CGFloat = 40

    private var panGesture = UIPanGestureRecognizer()

    // MARK: - property
    lazy var settingButton = SettingButton().then {
        let action = UIAction { [weak self] _ in
            let settingViewController = SettingViewController()
            self?.navigationController?.pushViewController(settingViewController, animated: true)
        }
        $0.addAction(action, for: .touchUpInside)
    }

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
        $0.layer.backgroundColor = UIColor.mainBackgroundColor.cgColor
        $0.layer.borderColor = UIColor.grey002.cgColor
        $0.layer.borderWidth = 1
        $0.layer.cornerRadius = 10
        $0.layer.masksToBounds = true
        $0.tintColor = UIColor.mainPink
    }

    lazy var bookmarkButton = BookmarkMapButton().then {
        $0.layer.backgroundColor = UIColor.mainBackgroundColor.cgColor
        $0.layer.borderColor = UIColor.grey002.cgColor
        $0.layer.borderWidth = 1
        $0.layer.cornerRadius = 10
        $0.layer.masksToBounds = true
        let action = UIAction { [weak self] _ in
            self?.tappedBookMarkButton()
        }
        $0.addAction(action, for: .touchUpInside)
    }

    let categoryListView = CategoryListView()

    let grabbarView = GrabbarView()

    lazy var feedListView = FeedListView(
        loadReviews: { await self.loadReviews() },
        reloadReviews: { await self.reloadReviews() },
        presentBlameVC: presentBlameVC
    )

    lazy var presentBlameVC: (Int, String) -> Void = { targetId, blameTarget in
        self.presentBlameViewController(targetId: targetId, blameTarget: blameTarget)
    }

    override func setupLayout() {
        view.addSubviews(mapView, categoryListView, trakingButton, bookmarkButton, grabbarView, feedListView)

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
            $0.trailing.equalToSuperview().inset(10)
            $0.top.equalTo(categoryListView.snp.bottom).offset(20)
            $0.height.width.equalTo(40)
        }

        bookmarkButton.snp.makeConstraints {
            $0.trailing.equalToSuperview().inset(10)
            $0.top.equalTo(trakingButton.snp.bottom).offset(8)
            $0.height.width.equalTo(40)
        }

        grabbarView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(80)
        }

        feedListView.snp.makeConstraints {
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

    override func loadData() {
        Task {
            feedListView.reviews = await loadReviews()
            stores = await loadStores()

            DispatchQueue.main.async {
                self.feedListView.listCollectionView.reloadData()
                self.feedListView.scrollToTop()
                self.grabbarView.modalResultLabel.text = "\(self.stores.count.prettyNumber)개의 맛집"
                self.setMarkers()
            }
        }
    }

    func loadReviews() async -> [Review] { return [] }

    func loadStores() async -> [Store] { return [] }

    func reloadReviews() async -> [Review] { return [] }

    func setMarkers() {
        mapView.removeAnnotations(markers)

        markers = stores.map { store in
            Marker(
                title: store.name,
                subtitle: "\(store.reviewCount)개의 후기",
                coordinate: CLLocationCoordinate2D(
                    latitude: store.y,
                    longitude: store.x
                ),
                glyphImage: Categories(rawValue: store.categoryName)?.icon,
                handler: { [weak self] in
                    let storeDetailViewController = StoreDetailViewController(storeId: store.id)
                    storeDetailViewController.title = store.name
                    self?.navigationController?.pushViewController(storeDetailViewController, animated: true)
                }
            )
        }

        mapView.addAnnotations(markers)
    }

    func tappedBookMarkButton() {
        bookmarkButton.isSelected.toggle()
        loadData()
    }
}

extension MapViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, didUpdate userLocation: MKUserLocation) {
        currentLoction = userLocation.location?.coordinate
    }

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

    func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
        let center = mapView.centerCoordinate
        let visibleMapRect = mapView.visibleMapRect
        let topLeftCoordinate = MKMapPoint(x: visibleMapRect.minX, y: visibleMapRect.minY).coordinate

        guard let currentLoc = currentLoction else { return }

        print(currentLoc)

        customLocation = CustomLocation(
            x: center.longitude,
            y: center.latitude,
            deltaX: abs(topLeftCoordinate.longitude - center.longitude),
            deltaY: abs(topLeftCoordinate.latitude - center.latitude),
            deviceX: currentLoc.longitude,
            deviceY: currentLoc.latitude
        )

        loadData()
    }
}

// MARK: - Control Modal
extension MapViewController {
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

        feedListView.snp.remakeConstraints {
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
                    self.feedListView.snp.updateConstraints {
                        $0.top.equalTo(self.grabbarView.snp.bottom)
                        $0.leading.trailing.bottom.equalToSuperview()
                        $0.height.equalTo(self.currentModalHeight)
                    }
                    self.feedListView.superview?.layoutIfNeeded()
                }
            )
        }
    }

    func modalMinState() {
        grabbarView.showResult()
        feedListView.listCollectionView.isHidden = true
        feedListView.borderLineView.isHidden = true
        tabBarController?.tabBar.frame.origin = CGPoint(x: 0, y: UIScreen.main.bounds.maxY)
    }

    func modalMidState() {
        grabbarView.showContent()
        feedListView.listCollectionView.isHidden = false
        feedListView.borderLineView.isHidden = false
        tabBarController?.tabBar.frame.origin = CGPoint(x: 0, y: UIScreen.main.bounds.maxY - tabBarHeight)
        grabbarView.layer.cornerRadius = 15
    }

    func modalMaxState() {
        grabbarView.layer.cornerRadius = 0
    }
}
