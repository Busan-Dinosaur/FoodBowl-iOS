//
//  MapViewController.swift
//  FoodBowl
//
//  Created by COBY_PRO on 2023/01/10.
//

import Combine
import CoreLocation
import MapKit
import UIKit

import SnapKit
import Then

enum MapViewType {
    case friend, univ, member
}

class MapViewController: UIViewController, Navigationable, Optionable {
    enum Section: CaseIterable {
        case main
    }
    
    // MARK: - ui component
    
    lazy var plusButton = PlusButton().then {
        let action = UIAction { [weak self] _ in
            let createReviewController = CreateReviewController()
            createReviewController.delegate = self
            let navigationController = UINavigationController(rootViewController: createReviewController)
            navigationController.modalPresentationStyle = .fullScreen
            DispatchQueue.main.async {
                self?.present(navigationController, animated: true)
            }
        }
        $0.addAction(action, for: .touchUpInside)
    }
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
    let feedListView = FeedListView()

    lazy var presentBlameVC: (Int, String) -> Void = { targetId, blameTarget in
        self.presentBlameViewController(targetId: targetId, blameTarget: blameTarget)
    }
    
    // MARK: - property
    
    private var cancelBag: Set<AnyCancellable> = Set()
    
    let customLocationPublisher = PassthroughSubject<CustomLocation, Never>()
    let bookmarkButtonDidTapPublisher: PassthroughSubject<StoreByReview, Never> = PassthroughSubject()
    
    let viewModel = MapViewModel()
    
    var dataSource: UICollectionViewDiffableDataSource<Section, Review>!
    var snapshot: NSDiffableDataSourceSnapshot<Section, Review>!
    
    var customLocation: CustomLocation?
    var currentLocation: CLLocationCoordinate2D?
    var markers = [Marker]()

    let modalMinHeight: CGFloat = 40
    let modalMidHeight: CGFloat = UIScreen.main.bounds.height / 2 - 100
    lazy var tabBarHeight: CGFloat = tabBarController?.tabBar.frame.height ?? 0
    lazy var navBarHeight: CGFloat = navigationController?.navigationBar.frame.height ?? 0
    lazy var modalMaxHeight: CGFloat = UIScreen.main.bounds.height - SizeLiteral.topAreaPadding - navBarHeight - 120
    var currentModalHeight: CGFloat = 0
    var categoryListHeight: CGFloat = 40

    private var panGesture = UIPanGestureRecognizer()
    
    init() {
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    // MARK: - life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureDataSource()
        self.setupLayout()
        self.configureUI()
        self.bindViewModel()
        self.bindUI()
        self.setupNavigation()
    }

    func setupLayout() {
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

    func configureUI() {
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePan(_:)))
        grabbarView.isUserInteractionEnabled = true
        grabbarView.addGestureRecognizer(panGesture)
        currentModalHeight = modalMidHeight
        bookmarkButton.isHidden = true
    }

    func tappedBookMarkButton() {
        bookmarkButton.isSelected.toggle()
        viewModel.isBookmark = bookmarkButton.isSelected
        if let customLocation = customLocation {
            customLocationPublisher.send(customLocation)
        }
    }
    
    // MARK: - func - bind

    private func bindViewModel() {
        let output = self.transformedOutput()
        self.bindOutputToViewModel(output)
    }
    
    private func bindOutputToViewModel(_ output: MapViewModel.Output) {
        output.reviews
            .receive(on: DispatchQueue.main)
            .sink { [weak self] result in
                switch result {
                case .failure:
                    self?.reloadReviews([])
                case .finished:
                    return
                }
            } receiveValue: { [weak self] reviews in
                self?.reloadReviews(reviews)
            }
            .store(in: &self.cancelBag)
        
        output.moreReviews
            .receive(on: DispatchQueue.main)
            .sink { [weak self] result in
                switch result {
                case .failure:
                    self?.loadMoreReviews([])
                case .finished:
                    return
                }
            } receiveValue: { [weak self] reviews in
                self?.loadMoreReviews(reviews)
            }
            .store(in: &self.cancelBag)
        
        output.stores
            .receive(on: DispatchQueue.main)
            .sink { [weak self] result in
                switch result {
                case .failure:
                    self?.handleStores([])
                case .finished:
                    return
                }
            } receiveValue: { [weak self] stores in
                self?.handleStores(stores)
            }
            .store(in: &self.cancelBag)
        
        output.refreshControl
            .receive(on: DispatchQueue.main)
            .sink { _ in
            } receiveValue: { [weak self] _ in
                self?.feedListView.refreshControl.endRefreshing()
            }
            .store(in: &self.cancelBag)
        
        output.bookmarkStore
            .receive(on: DispatchQueue.main)
            .sink { _ in
            } receiveValue: { [weak self] storeId in
                self?.updateBookmark(storeId)
            }
            .store(in: &self.cancelBag)
    }
    
    private func bindUI() {
    }
    
    // MARK: - func
    
    private func transformedOutput() -> MapViewModel.Output {
        let input = MapViewModel.Input(
            customLocation: self.customLocationPublisher.eraseToAnyPublisher(),
            scrolledToBottom: self.feedListView.listCollectionView.scrolledToBottomPublisher.eraseToAnyPublisher(),
            refreshControl: self.feedListView.refreshPublisher.eraseToAnyPublisher(),
            bookmarkButtonDidTap: self.bookmarkButtonDidTapPublisher.eraseToAnyPublisher()
        )

        return self.viewModel.transform(from: input)
    }
    
    private func bindCell(_ cell: FeedCollectionViewCell, with item: Review) {
        cell.userInfoView.userNameButton.tapPublisher
            .sink(receiveValue: { [weak self] _ in
                print("-------터치------")
                let viewController = ProfileViewController(memberId: item.writer.id)
                self?.navigationController?.pushViewController(viewController, animated: true)
            })
            .store(in: &self.cancelBag)
        
        cell.userInfoView.userImageButton.tapPublisher
            .sink(receiveValue: { [weak self] _ in
                print("-------터치------")
                let viewController = ProfileViewController(memberId: item.writer.id)
                self?.navigationController?.pushViewController(viewController, animated: true)
            })
            .store(in: &self.cancelBag)
        
        cell.userInfoView.optionButton.tapPublisher
            .sink(receiveValue: { [weak self] _ in
                let isOwn = UserDefaultsManager.currentUser?.id ?? 0 == item.writer.id
                self?.presentReviewOptionAlert(isOwn: isOwn, reviewId: item.review.id)
            })
            .store(in: &self.cancelBag)
        
        cell.storeInfoView.storeNameButton.tapPublisher
            .sink(receiveValue: { [weak self] _ in
                let storeDetailViewController = StoreDetailViewController(
                    viewModel: StoreDetailViewModel(storeId: item.store.id, isFriend: true)
                )
                self?.navigationController?.pushViewController(storeDetailViewController, animated: true)
            })
            .store(in: &self.cancelBag)
        
        cell.storeInfoView.bookmarkButton.tapPublisher
            .sink(receiveValue: { [weak self] _ in
                self?.bookmarkButtonDidTapPublisher.send(item.store)
            })
            .store(in: &self.cancelBag)
    }
    
    func removeReview(reviewId: Int) {
        print("삭제 동작")
    }
}

// MARK: - Helper
extension MapViewController {
    private func handleStores(_ stores: [Store]) {
        mapView.removeAnnotations(markers)

        markers = stores.map { store in
            Marker(
                title: store.name,
                subtitle: "\(store.reviewCount.prettyNumber)개의 후기",
                coordinate: CLLocationCoordinate2D(
                    latitude: store.y,
                    longitude: store.x
                ),
                glyphImage: Categories(rawValue: store.categoryName)?.icon,
                handler: { [weak self] in
                    let storeDetailViewController = StoreDetailViewController(
                        viewModel: StoreDetailViewModel(storeId: store.id, isFriend: true)
                    )
                    
                    DispatchQueue.main.async { [weak self] in
                        self?.navigationController?.pushViewController(storeDetailViewController, animated: true)
                    }
                }
            )
        }

        mapView.addAnnotations(markers)
        
        let reviewsCount = stores.reduce(0) { $0 + $1.reviewCount }
        grabbarView.modalResultLabel.text = "\(stores.count.prettyNumber)개의 맛집, \(reviewsCount.prettyNumber)개의 후기"
    }
}

// MARK: - DataSource
extension MapViewController {
    private func configureDataSource() {
        self.dataSource = self.feedCollectionViewDataSource()
        self.configureSnapshot()
    }

    private func feedCollectionViewDataSource() -> UICollectionViewDiffableDataSource<Section, Review> {
        let reviewCellRegistration = UICollectionView.CellRegistration<FeedCollectionViewCell, Review> {
            [weak self] cell, indexPath, item in
            cell.configureCell(item)
            self?.bindCell(cell, with: item)
        }

        return UICollectionViewDiffableDataSource(
            collectionView: self.feedListView.collectionView(),
            cellProvider: { collectionView, indexPath, item in
                return collectionView.dequeueConfiguredReusableCell(
                    using: reviewCellRegistration,
                    for: indexPath,
                    item: item
                )
            }
        )
    }
}

// MARK: - Snapshot
extension MapViewController {
    private func configureSnapshot() {
        self.snapshot = NSDiffableDataSourceSnapshot<Section, Review>()
        self.snapshot.appendSections([.main])
        self.dataSource.apply(self.snapshot, animatingDifferences: true)
    }

    private func reloadReviews(_ items: [Review]) {
        let previousReviewsData = self.snapshot.itemIdentifiers(inSection: .main)
        self.snapshot.deleteItems(previousReviewsData)
        self.snapshot.appendItems(items, toSection: .main)
        self.dataSource.apply(self.snapshot, animatingDifferences: true)
    }
    
    private func loadMoreReviews(_ items: [Review]) {
        self.snapshot.appendItems(items, toSection: .main)
        self.dataSource.apply(self.snapshot, animatingDifferences: true)
    }
    
    private func updateBookmark(_ storeId: Int) {
        for item in snapshot.itemIdentifiers {
            if item.store.id == storeId {
                var customItem = item
                customItem.store.isBookmarked.toggle()
                
                var newSnapshot = dataSource.snapshot()
                newSnapshot.reloadItems([customItem])
                
                self.dataSource.apply(newSnapshot)
            }
        }
    }
}

extension MapViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, didUpdate userLocation: MKUserLocation) {
        currentLocation = userLocation.location?.coordinate
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

        guard let currentLoc = currentLocation else { return }

        customLocation = CustomLocation(
            x: center.longitude,
            y: center.latitude,
            deltaX: abs(topLeftCoordinate.longitude - center.longitude),
            deltaY: abs(topLeftCoordinate.latitude - center.latitude),
            deviceX: currentLoc.longitude,
            deviceY: currentLoc.latitude
        )
        
        if let customLocation = customLocation {
            customLocationPublisher.send(customLocation)
        }
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

extension MapViewController: CreateReviewControllerDelegate {
    func updateData() {
        if let customLocation = customLocation {
            customLocationPublisher.send(customLocation)
        }
    }
}
