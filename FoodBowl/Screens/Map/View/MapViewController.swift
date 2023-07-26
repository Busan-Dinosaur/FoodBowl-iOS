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

class MapViewController: UIViewController {
    // 임시 마커 데이터
    private var marks: [Marker]?

    var panGesture = UIPanGestureRecognizer()

    var mapHeaderHeight: CGFloat {
        let scenes = UIApplication.shared.connectedScenes
        let windowScene = scenes.first as? UIWindowScene
        let window = windowScene?.windows.first
        let topPadding = window?.safeAreaInsets.top ?? 0
        let headerHeight = topPadding + 90
        return headerHeight
    }

    var modalMaxHeight: CGFloat {
        UIScreen.main.bounds.height - mapHeaderHeight - 30
    }

    var modalMinHeight: CGFloat {
        tabBarHeight - 20
    }

    let modalMidHeight: CGFloat = UIScreen.main.bounds.height / 2 - 80

    var tabBarHeight: CGFloat {
        tabBarController?.tabBar.frame.height ?? 0
    }

    var currentModalHeight: CGFloat = 0

    // MARK: - property
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

    private lazy var trakingButton = MKUserTrackingButton(mapView: mapView).then {
        $0.layer.backgroundColor = UIColor.mainBackground.cgColor
        $0.layer.borderColor = UIColor.grey002.cgColor
        $0.layer.borderWidth = 1
        $0.layer.cornerRadius = 10
        $0.layer.masksToBounds = true
        $0.tintColor = UIColor.mainPink
    }

    lazy var mapHeaderView = MapHeaderView().then {
        let findAction = UIAction { [weak self] _ in
            let findChooseViewController = FindChooseViewController()
            let navigationController = UINavigationController(rootViewController: findChooseViewController)
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
    }

    let grabbarView = GrabbarView()

    lazy var modalView: ModalView = .init()

    // MARK: - life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupLayout()
        configureUI()
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
        view.addSubviews(mapView, mapHeaderView, trakingButton, grabbarView, modalView)

        mapView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }

        mapHeaderView.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview()
            $0.height.equalTo(mapHeaderHeight)
        }

        trakingButton.snp.makeConstraints {
            $0.trailing.equalToSuperview().inset(BaseSize.horizantalPadding)
            $0.top.equalTo(mapHeaderView.snp.bottom).offset(20)
            $0.height.width.equalTo(40)
        }

        grabbarView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(30)
        }

        modalView.snp.makeConstraints {
            $0.top.equalTo(grabbarView.snp.bottom)
            $0.leading.trailing.bottom.equalToSuperview()
            $0.height.equalTo(modalMaxHeight)
        }
    }

    func configureUI() {
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePan(_:)))
        grabbarView.isUserInteractionEnabled = true
        grabbarView.addGestureRecognizer(panGesture)

        currentModalHeight = modalMaxHeight
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

    @objc
    func handlePan(_ gesture: UIPanGestureRecognizer) {
        guard gesture.view != nil else { return }
        let translation = gesture.translation(in: gesture.view?.superview)
        let grabbarRadius: CGFloat = 15

        var newModalHeight = currentModalHeight - translation.y
        if newModalHeight <= modalMinHeight {
            newModalHeight = modalMinHeight
            grabbarView.roundCorners(corners: [.topLeft, .topRight], radius: grabbarRadius)
            tabBarController?.tabBar.frame.origin = CGPoint(x: 0, y: UIScreen.main.bounds.maxY)
            modalView.showResult()
        } else if newModalHeight >= modalMaxHeight {
            newModalHeight = modalMaxHeight
            grabbarView.roundCorners(corners: [.topLeft, .topRight], radius: 0)
            tabBarController?.tabBar.frame.origin = CGPoint(x: 0, y: UIScreen.main.bounds.maxY - tabBarHeight)
            modalView.showContent()
        } else {
            grabbarView.roundCorners(corners: [.topLeft, .topRight], radius: grabbarRadius)
            tabBarController?.tabBar.frame.origin = CGPoint(x: 0, y: UIScreen.main.bounds.maxY - tabBarHeight)
            modalView.showContent()
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
                grabbarView.roundCorners(corners: [.topLeft, .topRight], radius: grabbarRadius)
                tabBarController?.tabBar.frame.origin = CGPoint(x: 0, y: UIScreen.main.bounds.maxY)
                modalView.showResult()
            case let height where height - modalMidHeight < modalMaxHeight - height:
                currentModalHeight = modalMidHeight
                grabbarView.roundCorners(corners: [.topLeft, .topRight], radius: grabbarRadius)
                tabBarController?.tabBar.frame.origin = CGPoint(x: 0, y: UIScreen.main.bounds.maxY - tabBarHeight)
                modalView.showContent()
            default:
                currentModalHeight = modalMaxHeight
                grabbarView.roundCorners(corners: [.topLeft, .topRight], radius: 0)
                tabBarController?.tabBar.frame.origin = CGPoint(x: 0, y: UIScreen.main.bounds.maxY - tabBarHeight)
                modalView.showContent()
            }

            modalView.snp.remakeConstraints {
                $0.top.equalTo(grabbarView.snp.bottom)
                $0.leading.trailing.bottom.equalToSuperview()
                $0.height.equalTo(currentModalHeight)
            }
        }
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

extension MapViewController: MFMailComposeViewControllerDelegate {
    func sendReportMail() {
        if MFMailComposeViewController.canSendMail() {
            let composeVC = MFMailComposeViewController()
            let emailAdress = "foodbowl5502@gmail.com"
            let messageBody = """
                내용을 작성해주세요.
                """

            composeVC.mailComposeDelegate = self
            composeVC.setToRecipients([emailAdress])
            composeVC.setSubject("[풋볼] 닉네임")
            composeVC.setMessageBody(messageBody, isHTML: false)
            composeVC.modalPresentationStyle = .fullScreen

            present(composeVC, animated: true, completion: nil)
        } else {
            showSendMailErrorAlert()
        }
    }

    private func showSendMailErrorAlert() {
        let sendMailErrorAlert = UIAlertController(title: "메일 전송 실패", message: "이메일 설정을 확인하고 다시 시도해주세요.", preferredStyle: .alert)
        let confirmAction = UIAlertAction(title: "확인", style: .default)
        sendMailErrorAlert.addAction(confirmAction)
        present(sendMailErrorAlert, animated: true, completion: nil)
    }

    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith _: MFMailComposeResult, error _: Error?) {
        controller.dismiss(animated: true, completion: nil)
    }
}
