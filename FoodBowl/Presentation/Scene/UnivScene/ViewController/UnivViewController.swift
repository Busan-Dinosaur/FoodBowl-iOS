//
//  UnivViewController.swift
//  FoodBowl
//
//  Created by COBY_PRO on 2023/07/18.
//

import MapKit
import Combine
import UIKit

import SnapKit
import Then

final class UnivViewController: MapViewController {
    
    // MARK: - ui component

    private lazy var univTitleButton = UnivTitleButton().then {
        let action = UIAction { [weak self] _ in
            let repository = SearchUnivRepositoryImpl()
            let usecase = SearchUnivUsecaseImpl(repository: repository)
            let viewModel = SearchUnivViewModel(usecase: usecase)
            let viewController = SearchUnivViewController(viewModel: viewModel)
            viewController.delegate = self
            let navigationController = UINavigationController(rootViewController: viewController)
            navigationController.modalPresentationStyle = .fullScreen
            
            DispatchQueue.main.async {
                self?.present(navigationController, animated: true)
            }
        }
        $0.addAction(action, for: .touchUpInside)
        $0.frame = CGRect(x: 0, y: 0, width: 300, height: 45)
        $0.label.text = UserDefaultStorage.schoolName ?? "대학가"
    }
    
    // MARK: - property
    
    private let setUnivPublisher = PassthroughSubject<Store, Never>()
    
    // MARK: - func - bind
    
    override func bindViewModel() {
        let output = self.transformedOutput()
        self.configureNavigation()
        self.bindOutputToViewModel(output)
    }
    
    private func transformedOutput() -> UnivViewModel.Output? {
        guard let viewModel = self.viewModel as? UnivViewModel else { return nil }
        let input = UnivViewModel.Input(
            viewDidLoad: self.viewDidLoadPublisher,
            setUniv: self.setUnivPublisher.eraseToAnyPublisher(),
            customLocation: self.locationPublisher.eraseToAnyPublisher(),
            bookmarkButtonDidTap: self.bookmarkButtonDidTapPublisher.eraseToAnyPublisher(),
            scrolledToBottom: self.feedListView.collectionView().scrolledToBottomPublisher.eraseToAnyPublisher(),
            refreshControl: self.feedListView.refreshPublisher.eraseToAnyPublisher()
        )
        return viewModel.transform(from: input)
    }
    
    private func bindOutputToViewModel(_ output: UnivViewModel.Output?) {
        guard let output else { return }
        
        output.univ
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { [weak self] schoolName, schoolX, schoolY in
                self?.univTitleButton.label.text = schoolName
                self?.moveCameraToUniv(schoolX: schoolX, schoolY: schoolY)
            })
            .store(in: &self.cancellable)
        
        output.stores
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { [weak self] result in
                switch result {
                case .success(let stores):
                    self?.setupMarkers(stores)
                case .failure(let error):
                    self?.makeAlert(
                        title: "에러",
                        message: error.localizedDescription
                    )
                }
            })
            .store(in: &self.cancellable)
        
        output.reviews
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { [weak self] result in
                switch result {
                case .success(let reviews):
                    self?.loadReviews(reviews)
                    self?.feedListView.refreshControl().endRefreshing()
                case .failure(let error):
                    self?.makeAlert(
                        title: "에러",
                        message: error.localizedDescription
                    )
                }
            })
            .store(in: &self.cancellable)
        
        output.moreReviews
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { [weak self] result in
                switch result {
                case .success(let reviews):
                    self?.loadMoreReviews(reviews)
                case .failure(let error):
                    self?.makeAlert(
                        title: "에러",
                        message: error.localizedDescription
                    )
                }
            })
            .store(in: &self.cancellable)
        
        output.isBookmark
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { [weak self] result in
                switch result {
                case .success(let storeId):
                    self?.updateBookmark(storeId)
                case .failure(let error):
                    self?.makeAlert(
                        title: "에러",
                        message: error.localizedDescription
                    )
                }
            })
            .store(in: &self.cancellable)
    }
    
    // MARK: - func
    
    private func configureNavigation() {
        let leftOffsetUnivTitleButton = removeBarButtonItem(with: univTitleButton, offsetX: 10)
        let univTitleButton = makeBarButtonItem(with: leftOffsetUnivTitleButton)
        let plusButton = makeBarButtonItem(with: plusButton)
        self.navigationItem.leftBarButtonItem = univTitleButton
        self.navigationItem.rightBarButtonItem = plusButton
    }

    private func moveCameraToUniv(schoolX: Double, schoolY: Double) {
        self.mapView.setRegion(
            MKCoordinateRegion(
                center: CLLocationCoordinate2D(latitude: schoolY, longitude: schoolX),
                span: MKCoordinateSpan(latitudeDelta: 0.02, longitudeDelta: 0.02)
            ),
            animated: true
        )
    }
}

extension UnivViewController {
    private func removeBarButtonItem(with button: UIButton, offsetX: CGFloat = 0, offsetY: CGFloat = 0) -> UIView {
        let offsetView = UIView(frame: CGRect(x: 0, y: 0, width: 300, height: 45))
        offsetView.bounds = offsetView.bounds.offsetBy(dx: offsetX, dy: offsetY)
        offsetView.addSubview(button)
        return offsetView
    }
}

extension UnivViewController: SearchUnivViewControllerDelegate {
    func setupUniv(univ: Store) {
        self.setUnivPublisher.send(univ)
    }
}
