//
//  SearchStoreViewController.swift
//  FoodBowl
//
//  Created by COBY_PRO on 2023/09/16.
//

import Combine
import UIKit

import SnapKit
import Then

final class SearchStoreViewController: UIViewController, Keyboardable {
    
    // MARK: - ui component
    
    private let searchStoreView: SearchStoreView = SearchStoreView()
    
    // MARK: - property
    
    private let viewModel: any BaseViewModelType
    private var cancellable: Set<AnyCancellable> = Set()
    
    let selectStorePublisher = PassthroughSubject<PlaceItemDTO, Never>()
    
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
        self.view = self.searchStoreView
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

    private func transformedOutput() -> SearchStoreViewModel.Output? {
        guard let viewModel = self.viewModel as? SearchStoreViewModel else { return nil }
        let input = SearchStoreViewModel.Input(
            searchStores: self.searchStoreView.searchStoresPublisher.eraseToAnyPublisher(),
            selectStore: self.selectStorePublisher.eraseToAnyPublisher()
        )
        return viewModel.transform(from: input)
    }
    
    private func bindOutputToViewModel(_ output: SearchStoreViewModel.Output?) {
        guard let output else { return }
        
        output.stores
            .receive(on: DispatchQueue.main)
            .sink { _ in
            } receiveValue: { [weak self] stores in
                self?.searchStoreView.stores = stores
                self?.searchStoreView.updateTableView()
            }
            .store(in: &self.cancellable)
        
        output.isSelected
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { [weak self] result in
                switch result {
                case .success:
                    self?.navigationController?.popViewController(animated: true)
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
        self.searchStoreView.cancelButtonDidTapPublisher
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { [weak self] _ in
                self?.navigationController?.popViewController(animated: true)
            })
            .store(in: &self.cancellable)
    }
    
    // MARK: - func
    
    private func configureDelegation() {
        self.searchStoreView.configureDateSourceDelegation(self)
        self.searchStoreView.configureDelegation(self)
    }
    
    private func configureNavigation() {
        guard let navigationController = self.navigationController else { return }
        self.searchStoreView.configureNavigationBarItem(navigationController)
    }
}

extension SearchStoreViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_: UITableView, numberOfRowsInSection _: Int) -> Int {
        return self.searchStoreView.stores.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView
            .dequeueReusableCell(withIdentifier: StoreSearchTableViewCell.className, for: indexPath) as? StoreSearchTableViewCell
        else { return UITableViewCell() }

        cell.selectionStyle = .none
        cell.storeNameLabel.text = self.searchStoreView.stores[indexPath.item].placeName
        cell.storeAdressLabel.text = self.searchStoreView.stores[indexPath.item].addressName
        cell.storeDistanceLabel.text = self.searchStoreView.stores[indexPath.item].distance.prettyDistance

        return cell
    }

    func tableView(_: UITableView, heightForRowAt _: IndexPath) -> CGFloat {
        return 60
    }

    func tableView(_: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.selectStorePublisher.send(self.searchStoreView.stores[indexPath.item])
    }
}
