//
//  SearchPlaceViewController.swift
//  FoodBowl
//
//  Created by COBY_PRO on 2023/09/18.
//

import Combine
import UIKit

import SnapKit
import Then

final class SearchPlaceViewController: UIViewController, Keyboardable, Helperable {
    
    // MARK: - ui component
    
    private let searchPlaceView: SearchPlaceView = SearchPlaceView()

    // MARK: - property
    
    private var places = [Store]()
    
    private let viewModel: any BaseViewModelType
    private var cancellable: Set<AnyCancellable> = Set()
    
    let searchPlacesPublisher = PassthroughSubject<String, Never>()
    
    weak var delegate: SearchPlaceViewControllerDelegate?

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
        self.view = self.searchPlaceView
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

    private func transformedOutput() -> SearchMyPlaceViewModel.Output? {
        guard let viewModel = self.viewModel as? SearchMyPlaceViewModel else { return nil }
        let input = SearchMyPlaceViewModel.Input(
            searchPlaces: self.searchPlacesPublisher.eraseToAnyPublisher()
        )
        return viewModel.transform(from: input)
    }
    
    private func bindOutputToViewModel(_ output: SearchMyPlaceViewModel.Output?) {
        guard let output else { return }

        output.places
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { [weak self] result in
                switch result {
                case .success(let places):
                    self?.places = places
                    self?.searchPlaceView.tableView().reloadData()
                case .failure(let error):
                    self?.makeErrorAlert(
                        title: "에러",
                        error: error
                    )
                }
            })
            .store(in: &self.cancellable)
    }
    
    private func bindUI() {
        self.searchPlaceView.closeButtonDidTapPublisher
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { [weak self] _ in
                self?.dismiss(animated: true)
            })
            .store(in: &self.cancellable)
    }
    
    // MARK: - func
    
    private func configureDelegation() {
        self.searchPlaceView.searchBar.delegate = self
        self.searchPlaceView.listTableView.delegate = self
        self.searchPlaceView.listTableView.dataSource = self
    }
    
    private func configureNavigation() {
        guard let navigationController = self.navigationController else { return }
        self.searchPlaceView.configureNavigationBarItem(navigationController)
    }
    
    private func setPlace(place: Store) {
        self.delegate?.setupPlace(place: place)
        self.dismiss(animated: true)
    }
}

extension SearchPlaceViewController: UISearchBarDelegate {
    private func dissmissKeyboard() {
        self.searchPlaceView.searchBar.resignFirstResponder()
    }

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        self.dissmissKeyboard()
    }

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText == "" {
            self.places = []
            self.searchPlaceView.tableView().reloadData()
        } else {
            self.searchPlacesPublisher.send(searchText)
        }
    }
}

extension SearchPlaceViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_: UITableView, numberOfRowsInSection _: Int) -> Int {
        if self.places.count == 0 {
            let emptyView = EmptyView(message: "검색된 장소가 없어요.")
            emptyView.findButtonTapAction = { [weak self] _ in
                self?.presentRecommendViewController()
            }
            
            self.searchPlaceView.tableView().backgroundView = emptyView
        } else {
            self.searchPlaceView.tableView().backgroundView = nil
        }
        
        return self.places.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView
            .dequeueReusableCell(withIdentifier: StoreTableViewCell.className, for: indexPath) as? StoreTableViewCell
        else { return UITableViewCell() }

        cell.selectionStyle = .none
        cell.configureCell(self.places[indexPath.item])

        return cell
    }

    func tableView(_: UITableView, heightForRowAt _: IndexPath) -> CGFloat {
        return 60
    }

    func tableView(_: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.setPlace(place: self.places[indexPath.item])
    }
}

protocol SearchPlaceViewControllerDelegate: AnyObject {
    func setupPlace(place: Store)
}
