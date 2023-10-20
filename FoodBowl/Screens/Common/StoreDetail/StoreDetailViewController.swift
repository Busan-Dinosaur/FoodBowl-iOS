//
//  StoreDetailViewController.swift
//  FoodBowl
//
//  Created by COBY_PRO on 2023/01/18.
//

import Combine
import UIKit

import SnapKit
import Then

protocol StoreDetailViewControllerDelegate: AnyObject {
}

final class StoreDetailViewController: UIViewController, Navigationable, Keyboardable {
    
    enum Section: CaseIterable {
        case main
    }
    
    // MARK: - ui component
    
    private lazy var storeDeatilView: StoreDeatilView = StoreDeatilView(storeId: self.viewModel.storeId, isFriend: self.viewModel.isFriend)
    
    // MARK: - property
    
    private var cancelBag: Set<AnyCancellable> = Set()

    private let viewModel: StoreDetailViewModel

    private weak var delegate: StoreDetailViewControllerDelegate?

    // MARK: - init
    
    init(viewModel: StoreDetailViewModel) {
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
        self.view = self.storeDeatilView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.bindViewModel()
        self.setupNavigation()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.storeDeatilView.configureNavigationBar(of: self)
    }
    
    // MARK: - func - bind

    private func bindViewModel() {
        let output = self.transformedOutput()
        self.bindOutputToViewModel(output)
    }
    
    private func transformedOutput() -> StoreDetailViewModel.Output {
        let input = StoreDetailViewModel.Input(
            viewDidLoad: self.viewDidLoadPublisher
        )

        return self.viewModel.transform(from: input)
    }

    private func bindOutputToViewModel(_ output: StoreDetailViewModel.Output) {
        output.reviews
            .receive(on: DispatchQueue.main)
            .sink { [weak self] result in
                switch result {
                case .failure(_):
                    self?.makeAlert(title: "리뷰 로드에 실패하셨습니다.")
                case .finished: return
                }
            } receiveValue: { [weak self] reviews in
                self?.handleReviews(reviews)
            }
            .store(in: &self.cancelBag)
    }
}

// MARK: - Helper
extension StoreDetailViewController {
    private func handleReviews(_ reviews: [ReviewByStore]) {
        self.storeDeatilView.reviews = reviews
        self.storeDeatilView.collectionView().reloadData()
    }
}
