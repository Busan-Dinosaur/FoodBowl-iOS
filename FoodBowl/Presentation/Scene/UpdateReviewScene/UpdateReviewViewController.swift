//
//  UpdateReviewViewController.swift
//  FoodBowl
//
//  Updated by COBY_PRO on 2023/09/12.
//

import Combine
import UIKit

import Kingfisher
import SnapKit
import Then

final class UpdateReviewViewController: UIViewController, Keyboardable, Helperable {
    
    // MARK: - ui component
    
    private let updateReviewView: UpdateReviewView = UpdateReviewView()
    
    // MARK: - property
    
    private var reviewImages = [UIImage]()
    
    private let viewModel: any BaseViewModelType
    private var cancellable: Set<AnyCancellable> = Set()

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
        self.view = self.updateReviewView
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
    
    private func transformedOutput() -> UpdateReviewViewModel.Output? {
        guard let viewModel = self.viewModel as? UpdateReviewViewModel else { return nil }
        let input = UpdateReviewViewModel.Input(
            viewDidLoad: self.viewDidLoadPublisher,
            completeButtonDidTap: self.updateReviewView.completeButtonDidTapPublisher.eraseToAnyPublisher()
        )
        return viewModel.transform(from: input)
    }
    
    private func bindOutputToViewModel(_ output: UpdateReviewViewModel.Output?) {
        guard let output else { return }
        
        output.review
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { [weak self] result in
                switch result {
                case .success(let review):
                    guard let self = self else { return }
                    self.updateReviewView.selectedStoreView.mapButtonTapAction = { _ in
                        self.presentShowWebViewController(url: review.store.url)
                    }
                    self.updateReviewView.configureReview(review)
                    self.downloadImages(from: review.comment.imagePaths) { images in
                        self.reviewImages = images
                        self.updateReviewView.collectionView().reloadData()
                    }
                case .failure(let error):
                    self?.makeAlert(
                        title: "에러",
                        message: error.localizedDescription
                    )
                }
            })
            .store(in: &self.cancellable)
        
        output.isCompleted
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { [weak self] result in
                switch result {
                case .success:
                    self?.makeAlert(
                        title: "후기",
                        message: "후기가 수정되었어요.",
                        okAction: { _ in
                            self?.dismiss(animated: true)
                        }
                    )
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
        self.updateReviewView.closeButtonDidTapPublisher
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { [weak self] _ in
                self?.makeRequestAlert(
                    title: "후기",
                    message: "후기를 수정하지 않으시나요?",
                    okTitle: "네",
                    cancelTitle: "아니요",
                    okAction: { _ in
                        self?.dismiss(animated: true)
                    }
                )
            })
            .store(in: &self.cancellable)
        
        self.updateReviewView.makeAlertPublisher
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { [weak self] message in
                self?.makeAlert(title: message)
            })
            .store(in: &self.cancellable)
        
        self.updateReviewView.showStorePublisher
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { [weak self] url in
                self?.presentShowWebViewController(url: url)
            })
            .store(in: &self.cancellable)
    }
    
    // MARK: - func
    
    private func configureDelegation() {
        self.updateReviewView.configureDelegation(self)
    }
    
    private func configureNavigation() {
        guard let navigationController = self.navigationController else { return }
        self.updateReviewView.configureNavigationBarItem(navigationController)
    }
}

extension UpdateReviewViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_: UICollectionView, numberOfItemsInSection _: Int) -> Int {
        return self.reviewImages.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: PhotoCollectionViewCell.className,
            for: indexPath
        ) as? PhotoCollectionViewCell else {
            return UICollectionViewCell()
        }
        
        cell.imageView.image = self.reviewImages[indexPath.item]
        
        return cell
    }
}

extension UpdateReviewViewController {
    func downloadImages(from urls: [String], completion: @escaping ([UIImage]) -> Void) {
        var images: [UIImage] = []
        let group = DispatchGroup()
        
        for urlString in urls {
            guard let url = URL(string: urlString) else { continue }
            
            group.enter()
            KingfisherManager.shared.retrieveImage(with: url) { result in
                switch result {
                case .success(let imageResult):
                    images.append(imageResult.image)
                case .failure(let error):
                    print("Error downloading image: \(error)")
                }
                group.leave()
            }
        }
        
        group.notify(queue: .main) {
            completion(images)
        }
    }
}
