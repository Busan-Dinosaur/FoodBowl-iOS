//
//  BaseViewController.swift
//  FoodBowl
//
//  Created by COBY_PRO on 2022/12/23.
//

import MessageUI
import UIKit

import Lottie
import Moya
import SnapKit
import Then

class BaseViewController: UIViewController {
    // MARK: - property
    var animationView: LottieAnimationView?

    private var activeTextField: UITextField?

    private lazy var backButton = BackButton().then {
        let buttonAction = UIAction { [weak self] _ in
            self?.navigationController?.popViewController(animated: true)
        }
        $0.addAction(buttonAction, for: .touchUpInside)
    }

    lazy var plusButton = PlusButton().then {
        let action = UIAction { [weak self] _ in
            let createReviewController = CreateReviewController()
            createReviewController.delegate = self
            let navigationController = UINavigationController(rootViewController: createReviewController)
            navigationController.modalPresentationStyle = .fullScreen
            DispatchQueue.main.async {
                self?.present(navigationController, animated: true)
            }
        }
        $0.addAction(action, for: .touchUpInside)
    }

    // MARK: - life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupLayout()
        configureUI()
        setupBackButton()
        hidekeyboardWhenTappedAround()
        setupNavigationBar()
        setupLottie()

        // Do any additional setup after loading the view.
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(BaseViewController.keyboardWillShow),
            name: UIResponder.keyboardWillShowNotification,
            object: nil
        )

        NotificationCenter.default.addObserver(
            self,
            selector: #selector(BaseViewController.keyboardWillHide),
            name: UIResponder.keyboardWillHideNotification,
            object: nil
        )
    }

    init() {
        super.init(nibName: nil, bundle: nil)
        renewToken()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupInteractivePopGestureRecognizer()
    }

    func setupLayout() {
        // Override Layout
    }

    func configureUI() {
        view.backgroundColor = .mainBackgroundColor
    }

    func setupNavigationBar() {
        guard let navigationBar = navigationController?.navigationBar else { return }
        let appearance = UINavigationBarAppearance()
        let font = UIFont.systemFont(ofSize: 17, weight: .regular)
        let largeFont = UIFont.systemFont(ofSize: 34, weight: .semibold)

        appearance.titleTextAttributes = [.font: font]
        appearance.largeTitleTextAttributes = [.font: largeFont]
        appearance.shadowColor = .clear
        appearance.backgroundColor = .mainBackgroundColor

        navigationBar.standardAppearance = appearance
        navigationBar.compactAppearance = appearance
        navigationBar.scrollEdgeAppearance = appearance
    }

    // MARK: - helper func
    func setupBackButton() {
        let leftOffsetBackButton = removeBarButtonItemOffset(with: backButton, offsetX: 10)
        let backButton = makeBarButtonItem(with: leftOffsetBackButton)

        navigationItem.leftBarButtonItem = backButton
    }

    func setupInteractivePopGestureRecognizer() {
        navigationController?.interactivePopGestureRecognizer?.delegate = self
    }

    func loadData() {}

    func setupLottie() {
        animationView = .init(name: "loading")
        animationView!.frame = view.bounds
        animationView!.center = view.center
        animationView!.contentMode = .scaleAspectFit
        animationView!.loopMode = .loop
        animationView!.play()
        animationView!.isHidden = true

        view.addSubview(animationView!)
    }

    // MARK: - func
    @objc
    func keyboardWillShow(notification: NSNotification) {
        guard let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else {
            // if keyboard size is not available for some reason, dont do anything
            return
        }

        var shouldMoveViewUp = false

        // if active text field is not nil
        if let activeTextField = activeTextField {
            let bottomOfTextField = activeTextField.convert(activeTextField.bounds, to: view).maxY
            let topOfKeyboard = view.frame.height - keyboardSize.height

            if bottomOfTextField > topOfKeyboard {
                shouldMoveViewUp = true
            }
        }

        if shouldMoveViewUp {
            view.frame.origin.y = 0 - keyboardSize.height
        }
    }

    @objc
    func keyboardWillHide(notification _: NSNotification) {
        view.frame.origin.y = 0
    }

    @objc
    func backgroundTap(_: UITapGestureRecognizer) {
        // go through all of the textfield inside the view, and end editing thus resigning first responder
        // ie. it will trigger a keyboardWillHide notification
        view.endEditing(true)
    }

    func presentBlameViewController(targetId: Int, blameTarget: String) {
        let createReviewController = BlameViewController(targetId: targetId, blameTarget: blameTarget)
        let navigationController = UINavigationController(rootViewController: createReviewController)
        navigationController.modalPresentationStyle = .fullScreen

        DispatchQueue.main.async {
            self.present(navigationController, animated: true)
        }
    }

    func renewToken() {
        let providerService = MoyaProvider<ServiceAPI>()
        providerService.request(.renew) { response in
            switch response {
            case .success(let result):
                guard let data = try? result.map(RenewResponse.self) else { return }
                KeychainManager.set(data.accessToken, for: .accessToken)
                KeychainManager.set(data.refreshToken, for: .refreshToken)
                print(data.accessToken)
            case .failure(let err):
                print(err.localizedDescription)
            }
        }
    }
}

extension BaseViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }

    func textFieldDidBeginEditing(_ textField: UITextField) {
        activeTextField = textField
    }

    func textFieldDidEndEditing(_: UITextField) {
        activeTextField = nil
    }
}

extension BaseViewController: UIGestureRecognizerDelegate {
    func gestureRecognizerShouldBegin(_: UIGestureRecognizer) -> Bool {
        guard let count = navigationController?.viewControllers.count else { return false }
        return count > 1
    }
}

extension BaseViewController: CreateReviewControllerDelegate {
    func updateData() {
        loadData()
    }
}
