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
            let repository = CreateReviewRepositoryImpl()
            let usecase = CreateReviewUsecaseImpl(repository: repository)
            let viewModel = CreateReviewViewModel(usecase: usecase)
            let viewController = CreateReviewViewController(viewModel: viewModel)
            let navigationController = UINavigationController(rootViewController: viewController)
            navigationController.modalPresentationStyle = .fullScreen
            
            DispatchQueue.main.async {
                self?.present(navigationController, animated: true)
            }
            
            viewController.delegate = self
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
    
    private var cancellable: Set<AnyCancellable> = Set()
    
    let customLocationPublisher = PassthroughSubject<CustomLocationRequestDTO, Never>()
    let bookmarkButtonDidTapPublisher: PassthroughSubject<StoreByReviewDTO, Never> = PassthroughSubject()
    
    let viewModel = MapViewModel()
    
    var dataSource: UICollectionViewDiffableDataSource<Section, ReviewItemDTO>!
    var snapshot: NSDiffableDataSourceSnapshot<Section, ReviewItemDTO>!
    
    var customLocation: CustomLocationRequestDTO?
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
        self.setupModal()
        self.bindViewModel()
        self.bindUI()
        self.setupNavigation()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.setModalState()
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
        self.view.backgroundColor = .mainBackgroundColor
    }
    
    func setupModal() {
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePan(_:)))
        self.grabbarView.isUserInteractionEnabled = true
        self.grabbarView.addGestureRecognizer(panGesture)
        self.currentModalHeight = self.modalMidHeight
        self.bookmarkButton.isHidden = true
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
            .sink { _ in
            } receiveValue: { [weak self] reviews in
                self?.reloadReviews(reviews)
            }
            .store(in: &self.cancellable)
        
        output.moreReviews
            .receive(on: DispatchQueue.main)
            .sink { _ in
            } receiveValue: { [weak self] reviews in
                self?.loadMoreReviews(reviews)
            }
            .store(in: &self.cancellable)
        
        output.stores
            .receive(on: DispatchQueue.main)
            .sink { _ in
            } receiveValue: { [weak self] stores in
                self?.handleStores(stores)
            }
            .store(in: &self.cancellable)
        
        output.refreshControl
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { [weak self] _ in
                self?.feedListView.refreshControl.endRefreshing()
            })
            .store(in: &self.cancellable)
    }
    
    private func bindUI() {
    }
    
    // MARK: - func
    
    private func transformedOutput() -> MapViewModel.Output {
        let input = MapViewModel.Input(
            customLocation: self.customLocationPublisher.eraseToAnyPublisher(),
            scrolledToBottom: self.feedListView.collectionView().scrolledToBottomPublisher.eraseToAnyPublisher(),
            refreshControl: self.feedListView.refreshPublisher.eraseToAnyPublisher()
        )

        return self.viewModel.transform(from: input)
    }
    
    private func bindCell(_ cell: FeedCollectionViewCell, with item: ReviewItemDTO) {
        cell.userButtonTapAction = { [weak self] _ in
            self?.presentProfileViewController(id: item.writer.id)
        }
        
        cell.optionButtonTapAction = { [weak self] _ in
            let isOwn = UserDefaultStorage.id == item.writer.id
            
            DispatchQueue.main.async { [weak self] in
                self?.presentReviewOptionAlert(reviewId: item.review.id)
            }
        }
        
        cell.storeButtonTapAction = { [weak self] _ in
            self?.presentStoreDetailViewController(id: item.store.id)
        }
        
        cell.bookmarkButtonTapAction = { [weak self] _ in
            guard let self = self else { return }
            
            Task {
                if cell.storeInfoButton.bookmarkButton.isSelected {
                    if await self.viewModel.removeBookmark(storeId: item.store.id) {
                        DispatchQueue.main.async {
                            self.updateBookmark(item.store.id)
                        }
                    }
                } else {
                    if await self.viewModel.createBookmark(storeId: item.store.id) {
                        DispatchQueue.main.async {
                            self.updateBookmark(item.store.id)
                        }
                    }
                }
            }
        }
        
        cell.cellTapAction = { [weak self] _ in
            self?.presentReviewDetailViewController(id: item.review.id)
        }
    }
    
    func removeReview(reviewId: Int) {
        Task {
            if await self.viewModel.removeReview(id: reviewId) {
                self.deleteReview(reviewId)
            }
        }
    }
}

// MARK: - Modal
extension MapViewController {
}

// MARK: - Helper
extension MapViewController {
    private func handleStores(_ stores: [StoreItemDTO]) {
        mapView.removeAnnotations(markers)

        markers = stores.map { store in
            Marker(
                title: store.name,
                subtitle: "\(store.reviewCount.prettyNumber)개의 후기",
                coordinate: CLLocationCoordinate2D(
                    latitude: store.y,
                    longitude: store.x
                ),
                glyphImage: CategoryType(rawValue: store.categoryName)?.icon,
                handler: { [weak self] in
                    self?.presentStoreDetailViewController(id: store.id)
                }
            )
        }

        mapView.addAnnotations(markers)
        grabbarView.modalResultLabel.text = "\(stores.count.prettyNumber)개의 맛집"
    }
}

// MARK: - DataSource
extension MapViewController {
    private func configureDataSource() {
        self.dataSource = self.feedCollectionViewDataSource()
        self.configureSnapshot()
    }

    private func feedCollectionViewDataSource() -> UICollectionViewDiffableDataSource<Section, ReviewItemDTO> {
        let reviewCellRegistration = UICollectionView.CellRegistration<FeedCollectionViewCell, ReviewItemDTO> {
            [weak self] cell, indexPath, item in
            cell.configureCell(item.toReview())
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
        self.snapshot = NSDiffableDataSourceSnapshot<Section, ReviewItemDTO>()
        self.snapshot.appendSections([.main])
        self.dataSource.apply(self.snapshot, animatingDifferences: true)
    }

    private func reloadReviews(_ items: [ReviewItemDTO]) {
        let previousReviewsData = self.snapshot.itemIdentifiers(inSection: .main)
        self.snapshot.deleteItems(previousReviewsData)
        self.snapshot.appendItems(items, toSection: .main)
        self.dataSource.applySnapshotUsingReloadData(self.snapshot)
    }
    
    private func loadMoreReviews(_ items: [ReviewItemDTO]) {
        self.snapshot.appendItems(items, toSection: .main)
        self.dataSource.applySnapshotUsingReloadData(self.snapshot)
    }
    
    private func updateBookmark(_ storeId: Int) {
        let previousReviewsData = self.snapshot.itemIdentifiers(inSection: .main)
        let items = previousReviewsData
            .map { customItem in
                var updatedItem = customItem
                if customItem.store.id == storeId {
                    updatedItem.store.isBookmarked.toggle()
                }
                return updatedItem
            }
        self.snapshot.deleteItems(previousReviewsData)
        self.snapshot.appendItems(items)
        self.dataSource.applySnapshotUsingReloadData(self.snapshot)
    }
    
    private func deleteReview(_ reviewId: Int) {
        for item in snapshot.itemIdentifiers {
            if item.review.id == reviewId {
                self.snapshot.deleteItems([item])
                self.dataSource.apply(self.snapshot)
                return
            }
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

    func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
        let center = mapView.centerCoordinate
        let visibleMapRect = mapView.visibleMapRect
        let topLeftCoordinate = MKMapPoint(x: visibleMapRect.minX, y: visibleMapRect.minY).coordinate
        
        guard let location = LocationManager.shared.manager.location?.coordinate else { return }
        self.customLocation = CustomLocationRequestDTO(
            x: center.longitude,
            y: center.latitude,
            deltaX: abs(topLeftCoordinate.longitude - center.longitude),
            deltaY: abs(topLeftCoordinate.latitude - center.latitude),
            deviceX: location.longitude,
            deviceY: location.latitude
        )
        
        if let customLocation = self.customLocation {
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
        
        var newModalHeight = self.currentModalHeight - translation.y
        switch newModalHeight {
        case ...self.modalMinHeight:
            newModalHeight = self.modalMinHeight
            self.setModalMinState()
        case ...self.modalMaxHeight:
            self.setModalMidState()
        default:
            newModalHeight = modalMaxHeight
            self.setModalMaxState()
        }

        self.feedListView.snp.remakeConstraints {
            $0.top.equalTo(self.grabbarView.snp.bottom)
            $0.leading.trailing.bottom.equalToSuperview()
            $0.height.equalTo(newModalHeight)
        }

        if gesture.state == .ended {
            switch newModalHeight {
            case let height where height - self.modalMinHeight < self.modalMidHeight - height:
                self.currentModalHeight = self.modalMinHeight
            case let height where height - self.modalMidHeight < self.modalMaxHeight - height:
                self.currentModalHeight = self.modalMidHeight
            default:
                self.currentModalHeight = self.modalMaxHeight
            }
            
            self.setModalState()

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
    
    private func setModalState() {
        switch self.currentModalHeight {
        case self.modalMinHeight:
            self.setModalMinState()
        case self.modalMidHeight:
            self.setModalMidState()
        default:
            self.setModalMaxState()
        }
    }

    private func setModalMinState() {
        self.grabbarView.showResult()
        self.feedListView.listCollectionView.isHidden = true
        self.feedListView.borderLineView.isHidden = true
        self.tabBarController?.tabBar.frame.origin = CGPoint(x: 0, y: UIScreen.main.bounds.maxY)
    }

    private func setModalMidState() {
        self.grabbarView.layer.cornerRadius = 15
        self.grabbarView.showContent()
        self.feedListView.listCollectionView.isHidden = false
        self.feedListView.borderLineView.isHidden = false
        self.tabBarController?.tabBar.frame.origin = CGPoint(x: 0, y: UIScreen.main.bounds.maxY - self.tabBarHeight)
    }

    private func setModalMaxState() {
        self.grabbarView.layer.cornerRadius = 0
    }
}

extension MapViewController: CreateReviewViewControllerDelegate {
    func updateData() {
        if let customLocation = customLocation {
            customLocationPublisher.send(customLocation)
        }
    }
}

// MARK: - Helper
extension MapViewController {
    private func presentProfileViewController(id: Int) {
        let profileViewController = ProfileViewController(memberId: id)
        
        DispatchQueue.main.async { [weak self] in
            self?.navigationController?.pushViewController(profileViewController, animated: true)
        }
    }
    
    private func presentStoreDetailViewController(id: Int) {
        let repository = StoreDetailRepositoryImpl()
        let usecase = StoreDetailUsecaseImpl(repository: repository)
        let viewModel = StoreDetailViewModel(
            usecase: usecase,
            storeId: id
        )
        let viewController = StoreDetailViewController(viewModel: viewModel)
        self.navigationController?.pushViewController(viewController, animated: true)
    }
    
    private func presentReviewDetailViewController(id: Int) {
        let repository = ReviewDetailRepositoryImpl()
        let usecase = ReviewDetailUsecaseImpl(repository: repository)
        let viewModel = ReviewDetailViewModel(
            usecase: usecase,
            reviewId: id
        )
        let viewController = ReviewDetailViewController(viewModel: viewModel)
        self.navigationController?.pushViewController(viewController, animated: true)
    }
}
