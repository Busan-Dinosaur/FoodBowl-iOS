//
//  EditProfileViewController.swift
//  FoodBowl
//
//  Created by COBY_PRO on 2023/01/26.
//

import Combine
import UIKit

import SnapKit
import Then

final class EditProfileViewController: UIViewController, Navigationable, Keyboardable, PhotoPickerable {
    
    // MARK: - ui component
    
    private let editProfileView: EditProfileView = EditProfileView()
    
    // MARK: - property
    
    private let viewModel: any BaseViewModelType
    private var cancellable: Set<AnyCancellable> = Set()
    
    let setProfileImagePublisher = PassthroughSubject<UIImage, Never>()
    
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
        self.view = self.editProfileView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.bindViewModel()
        self.bindUI()
        self.setupNavigation()
        self.setupKeyboardGesture()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.isHidden = true
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.tabBarController?.tabBar.isHidden = false
    }
    
    // MARK: - func - bind
    
    private func bindViewModel() {
        let output = self.transformedOutput()
        self.configureNavigation()
        self.bindOutputToViewModel(output)
    }
    
    private func transformedOutput() -> EditProfileViewModel.Output? {
        guard let viewModel = self.viewModel as? EditProfileViewModel else { return nil }
        let input = EditProfileViewModel.Input(
            viewDidLoad: self.viewDidLoadPublisher,
            setProfileImage: self.setProfileImagePublisher.eraseToAnyPublisher(),
            completeButtonDidTap: self.editProfileView.completeButtonDidTapPublisher.eraseToAnyPublisher()
        )
        return viewModel.transform(from: input)
    }
    
    private func bindOutputToViewModel(_ output: EditProfileViewModel.Output?) {
        guard let output else { return }
        
        output.profile
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { [weak self] result in
                switch result {
                case .success(let profile):
                    self?.editProfileView.configureView(member: profile)
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
        self.editProfileView.profileImageButtonDidTapPublisher
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { [weak self] _ in
                self?.photoAddButtonDidTap()
            })
            .store(in: &self.cancellable)
        
        self.editProfileView.makeAlertPublisher
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { [weak self] message in
                self?.makeAlert(title: message)
            })
            .store(in: &self.cancellable)
    }
    
    // MARK: - func
    
    private func configureNavigation() {
        guard let navigationController = self.navigationController else { return }
        self.editProfileView.configureNavigationBarTitle(navigationController)
    }
    
    func setPhoto(image: UIImage) {
        self.editProfileView.profileImageButton.setImage(image, for: .normal)
        self.setProfileImagePublisher.send(image)
    }
}
