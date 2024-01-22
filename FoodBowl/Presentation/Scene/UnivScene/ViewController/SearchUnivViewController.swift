//
//  SearchUnivViewController.swift
//  FoodBowl
//
//  Created by COBY_PRO on 2023/09/18.
//

import Combine
import UIKit

import SnapKit
import Then

final class SearchUnivViewController: UIViewController, Keyboardable {
    
    // MARK: - ui component
    
    private let searchUnivView: SearchUnivView = SearchUnivView()

    // MARK: - property
    
    private var univs = [Store]()
    private var filteredUnivs = [Store]()
    
    private let viewModel: any BaseViewModelType
    private var cancellable: Set<AnyCancellable> = Set()
    
    weak var delegate: SearchUnivViewControllerDelegate?

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
        self.view = self.searchUnivView
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

    private func transformedOutput() -> SearchUnivViewModel.Output? {
        guard let viewModel = self.viewModel as? SearchUnivViewModel else { return nil }
        let input = SearchUnivViewModel.Input(
            viewDidLoad: self.viewDidLoadPublisher
        )
        return viewModel.transform(from: input)
    }
    
    private func bindOutputToViewModel(_ output: SearchUnivViewModel.Output?) {
        guard let output else { return }

        output.univs
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { [weak self] result in
                switch result {
                case .success(let univs):
                    self?.univs = univs
                    self?.filteredUnivs = univs
                    self?.searchUnivView.tableView().reloadData()
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
        self.searchUnivView.closeButtonDidTapPublisher
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { [weak self] _ in
                self?.dismiss(animated: true)
            })
            .store(in: &self.cancellable)
    }
    
    // MARK: - func
    
    private func configureDelegation() {
        self.searchUnivView.searchBar.delegate = self
        self.searchUnivView.listTableView.delegate = self
        self.searchUnivView.listTableView.dataSource = self
    }
    
    private func configureNavigation() {
        guard let navigationController = self.navigationController else { return }
        self.searchUnivView.configureNavigationBarItem(navigationController)
    }
    
    private func setUniv(univ: Store) {
        self.delegate?.setUniv(univ: univ)
        self.dismiss(animated: true)
    }
}

extension SearchUnivViewController: UISearchBarDelegate {
    private func dissmissKeyboard() {
        self.searchUnivView.searchBar.resignFirstResponder()
    }

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        self.dissmissKeyboard()
    }

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText == "" {
            self.filteredUnivs = univs
        } else {
            self.filteredUnivs = univs.filter { $0.name.contains(searchText) }
        }
        self.searchUnivView.listTableView.reloadData()
    }
}

extension SearchUnivViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_: UITableView, numberOfRowsInSection _: Int) -> Int {
        return self.filteredUnivs.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView
            .dequeueReusableCell(withIdentifier: StoreTableViewCell.className, for: indexPath) as? StoreTableViewCell
        else { return UITableViewCell() }

        cell.selectionStyle = .none
        cell.configureCell(filteredUnivs[indexPath.item])

        return cell
    }

    func tableView(_: UITableView, heightForRowAt _: IndexPath) -> CGFloat {
        return 60
    }

    func tableView(_: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.setUniv(univ: filteredUnivs[indexPath.item])
    }
}

protocol SearchUnivViewControllerDelegate: AnyObject {
    func setUniv(univ: Store)
}
