//
//  CreateReviewViewController.swift
//  FoodBowl
//
//  Created by COBY_PRO on 2023/09/16.
//

import Combine
import UIKit

import SnapKit
import Then

final class CreateReviewViewController: UIViewController, Keyboardable, PhotoPickerable {
    
    // MARK: - ui component
    
    private let createReviewView: CreateReviewView = CreateReviewView()
    
    // MARK: - property
    
    private var reviewImages = [UIImage]()
    
    private let viewModel: any BaseViewModelType
    private var cancellable: Set<AnyCancellable> = Set()
    
    let setStorePublisher = PassthroughSubject<(Place, Place?), Never>()
    
    weak var delegate: CreateReviewViewControllerDelegate?
    
    // MARK: - init
    
    init(viewModel: any BaseViewModelType) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        print("\(#file) is dead")
    }
    
    // MARK: - life cycle
    
    override func loadView() {
        self.view = self.createReviewView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureDelegation()
        self.bindViewModel()
        self.bindUI()
        self.setupKeyboardGesture()
    }
    
    // MARK: - func - bind
    
    private func bindViewModel() {
        let output = self.transformedOutput()
        self.configureNavigation()
        self.bindOutputToViewModel(output)
    }
    
    private func transformedOutput() -> CreateReviewViewModel.Output? {
        guard let viewModel = self.viewModel as? CreateReviewViewModel else { return nil }
        let input = CreateReviewViewModel.Input(
            completeButtonDidTap: self.createReviewView.completeButtonDidTapPublisher.eraseToAnyPublisher(),
            setStore: self.setStorePublisher.eraseToAnyPublisher()
        )
        return viewModel.transform(from: input)
    }
    
    private func bindOutputToViewModel(_ output: CreateReviewViewModel.Output?) {
        guard let output else { return }
        
        output.isCompleted
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { [weak self] result in
                switch result {
                case .success:
                    self?.delegate?.updateData()
                    self?.dismiss(animated: true)
                case .failure(let error):
                    self?.makeAlert(
                        title: "에러",
                        message: error.localizedDescription
                    )
                }
            })
            .store(in: &self.cancellable)
    }
    
    private func bindUI() {
        self.createReviewView.closeButtonDidTapPublisher
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { [weak self] _ in
                self?.dismiss(animated: true)
            })
            .store(in: &self.cancellable)
        
        self.createReviewView.searchBarButtonDidTapPublisher
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { [weak self] _ in
                self?.presentSearchStoreViewController()
            })
            .store(in: &self.cancellable)
        
        self.createReviewView.maxLengthAlertPublisher
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { [weak self] _ in
                self?.makeAlert(title: "100자 이하로 작성해주세요.")
            })
            .store(in: &self.cancellable)
        
        self.createReviewView.maxLineAlertPublisher
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { [weak self] _ in
                self?.makeAlert(title: "5번 이내로 줄바꿈이 가능해요.")
            })
            .store(in: &self.cancellable)
        
        self.createReviewView.showStorePublisher
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { [weak self] url in
                self?.presentShowStoreViewController(url: url)
            })
            .store(in: &self.cancellable)
    }
    
    // MARK: - func
    
    private func configureDelegation() {
        self.createReviewView.configureDelegation(self)
    }
    
    private func configureNavigation() {
        guard let navigationController = self.navigationController else { return }
        self.createReviewView.configureNavigationBarItem(navigationController)
    }
    
    @objc
    private func photoPlusCellDidTap() {
        self.photoAddButtonDidTap()
    }
    
    func setPhotoes(images: [UIImage]) {
        self.reviewImages = images
        self.createReviewView.setImages(images: images)
        self.createReviewView.collectionView().reloadData()
    }
}

extension CreateReviewViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_: UICollectionView, numberOfItemsInSection _: Int) -> Int {
        return self.reviewImages.count + 1
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.item == 0 {
            guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: PhotoPlusCollectionViewCell.className,
                for: indexPath
            ) as? PhotoPlusCollectionViewCell else {
                return UICollectionViewCell()
            }
            
            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.photoPlusCellDidTap))
            cell.addGestureRecognizer(tapGesture)

            return cell
        } else {
            guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: PhotoCollectionViewCell.className,
                for: indexPath
            ) as? PhotoCollectionViewCell else {
                return UICollectionViewCell()
            }

            cell.imageView.image = self.reviewImages[indexPath.item - 1]

            return cell
        }
    }
}

// MARK: - Helper
extension CreateReviewViewController {
    private func presentSearchStoreViewController() {
        let repository = CreateReviewRepositoryImpl()
        let usecase = CreateReviewUsecaseImpl(repository: repository)
        let viewModel = SearchStoreViewModel(usecase: usecase)
        let viewController = SearchStoreViewController(viewModel: viewModel)
        viewController.delegate = self
        self.navigationController?.pushViewController(viewController, animated: true)
    }
    
    private func presentShowStoreViewController(url: String) {
        let showWebViewController = ShowWebViewController(url: url)
        let navigationController = UINavigationController(rootViewController: showWebViewController)
        self.navigationController?.present(navigationController, animated: true)
    }
}

protocol CreateReviewViewControllerDelegate: AnyObject {
    func updateData()
}

extension CreateReviewViewController: SearchStoreViewControllerDelegate {
    func setStore(store: Place, univ: Place?) {
        self.setStorePublisher.send((store, univ))
        self.createReviewView.setStore(store: store)
    }
}
