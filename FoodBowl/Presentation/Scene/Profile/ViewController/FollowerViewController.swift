//
//  FollowerViewController.swift
//  FoodBowl
//
//  Created by COBY_PRO on 2023/01/19.
//

import Combine
import UIKit

import SnapKit
import Then

final class FollowerViewController: UIViewController, Navigationable {
    
    // MARK: - ui component
    
    private let followerView: FollowerView = FollowerView()
    
    // MARK: - property
    
    private var cancelBag: Set<AnyCancellable> = Set()
    private let viewModel: any BaseViewModelType
    
    // MARK: - init
    
    init(viewModel: any BaseViewModelType) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - life cycle
    
    override func loadView() {
        self.view = self.followerView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.bindViewModel()
        self.setupNavigation()
        self.setupNavigationBar()
    }
    
    // MARK: - func
    
    private func setupNavigationBar() {
        title = "팔로워"
    }
    
    private func bindViewModel() {
        let output = self.transformedOutput()
        self.bindOutputToViewModel(output)
    }
    
    private func bindOutputToViewModel(_ output: FollowerViewModel.Output?) {
        guard let output else { return }
        
        output.followers
            .receive(on: DispatchQueue.main)
            .sink { [weak self] result in
                switch result {
                case .failure:
                    return
                case .finished:
                    return
                }
            } receiveValue: { [weak self] followers in
                self?.followerView.members = followers
            }
            .store(in: &self.cancelBag)
    }
    
    private func transformedOutput() -> FollowerViewModel.Output? {
        guard let viewModel = self.viewModel as? FollowerViewModel else { return nil }
        
        let input = FollowerViewModel.Input(
            scrolledToBottom: self.followerView.listTableView.scrolledToBottomPublisher.eraseToAnyPublisher()
        )
        return viewModel.transform(from: input)
    }
}
