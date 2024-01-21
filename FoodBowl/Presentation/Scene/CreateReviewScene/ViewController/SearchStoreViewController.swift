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
    
    private var stores: [Place] = []
    
    private let viewModel: any BaseViewModelType
    private var cancellable: Set<AnyCancellable> = Set()
    
    let searchStoresPublisher = PassthroughSubject<String, Never>()
    let selectStorePublisher = PassthroughSubject<Place, Never>()
    
    weak var delegate: SearchStoreViewControllerDelegate?
    
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
        self.view.endEditing(true)
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
            searchStores: self.searchStoresPublisher.eraseToAnyPublisher(),
            selectStore: self.selectStorePublisher.eraseToAnyPublisher()
        )
        return viewModel.transform(from: input)
    }
    
    private func bindOutputToViewModel(_ output: SearchStoreViewModel.Output?) {
        guard let output else { return }

        output.stores
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { [weak self] result in
                switch result {
                case .success(let stores):
                    self?.stores = stores
                    self?.searchStoreView.tableView().reloadData()
                case .failure(let error):
                    self?.makeAlert(
                        title: "에러",
                        message: error.localizedDescription
                    )
                }
            })
            .store(in: &self.cancellable)
        
        output.isSelected
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { [weak self] result in
                switch result {
                case .success((let store, let univ)):
                    self?.delegate?.setStore(store: store, univ: univ)
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
        self.searchStoreView.searchBar.delegate = self
        self.searchStoreView.tableView().delegate = self
        self.searchStoreView.tableView().dataSource = self
    }
    
    private func configureNavigation() {
        guard let navigationController = self.navigationController else { return }
        self.searchStoreView.configureNavigationBarItem(navigationController)
    }
}

extension SearchStoreViewController: UISearchBarDelegate {
    private func dissmissKeyboard() {
        self.searchStoreView.searchBar.resignFirstResponder()
    }

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        dissmissKeyboard()
    }

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        guard let text = searchBar.text, text != "" else {
            self.stores = []
            self.searchStoreView.tableView().reloadData()
            return
        }
        self.searchStoresPublisher.send(text)
    }
}

extension SearchStoreViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_: UITableView, numberOfRowsInSection _: Int) -> Int {
        return self.stores.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView
            .dequeueReusableCell(withIdentifier: StoreSearchTableViewCell.className, for: indexPath) as? StoreSearchTableViewCell
        else { return UITableViewCell() }

        cell.selectionStyle = .none
        cell.configureCell(self.stores[indexPath.item])

        return cell
    }

    func tableView(_: UITableView, heightForRowAt _: IndexPath) -> CGFloat {
        return 60
    }

    func tableView(_: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.selectStorePublisher.send(self.stores[indexPath.item])
    }
}

protocol SearchStoreViewControllerDelegate: AnyObject {
    func setStore(store: Place, univ: Place?)
}
