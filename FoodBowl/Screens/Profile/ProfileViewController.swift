//
//  ProfileViewController.swift
//  FoodBowl
//
//  Created by COBY_PRO on 2022/12/23.
//

import UIKit

import SnapKit
import Then

final class ProfileViewController: BaseViewController {
    var isOwn: Bool

    init(isOwn: Bool) {
        self.isOwn = isOwn
        super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - property

    let userNicknameLabel = UILabel().then {
        $0.font = UIFont.preferredFont(forTextStyle: .title1, weight: .bold)
        $0.text = "coby5502"
    }

    private lazy var settingButton = SettingButton().then {
        let settingAction = UIAction { [weak self] _ in
            let settingViewController = SettingViewController()
            self?.navigationController?.pushViewController(settingViewController, animated: true)
        }
        $0.addAction(settingAction, for: .touchUpInside)
    }

    private lazy var mapButton = MapButton().then {
        let mapAction = UIAction { [weak self] _ in
            let userMapViewController = UserMapViewController()
            self?.navigationController?.pushViewController(userMapViewController, animated: true)
        }
        $0.addAction(mapAction, for: .touchUpInside)
    }

    private let optionButton = OptionButton()

    private lazy var userProfileView = UserProfileView().then {
        let followerAction = UIAction { [weak self] _ in
            let followerViewController = FollowerViewController()
            self?.navigationController?.pushViewController(followerViewController, animated: true)
        }

        let followingAction = UIAction { [weak self] _ in
            let followingViewController = FollowingViewController()
            self?.navigationController?.pushViewController(followingViewController, animated: true)
        }

        let followButtonAction = UIAction { [weak self] _ in
            self?.followUser()
        }

        let editButtonAction = UIAction { [weak self] _ in
            let editProfileViewController = EditProfileViewController()
            let navigationController = UINavigationController(rootViewController: editProfileViewController)
            navigationController.modalPresentationStyle = .fullScreen
            DispatchQueue.main.async {
                self?.present(navigationController, animated: true)
            }
        }

        $0.followerInfoButton.addAction(followerAction, for: .touchUpInside)
        $0.followingInfoButton.addAction(followingAction, for: .touchUpInside)
        $0.followButton.addAction(followButtonAction, for: .touchUpInside)
        $0.editButton.addAction(editButtonAction, for: .touchUpInside)
    }

    private lazy var segmentedControl = UnderlineSegmentedControl(items: ["게시물 24", "북마크 53"]).then {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.setTitleTextAttributes(
            [
                NSAttributedString.Key.foregroundColor: UIColor.grey001,
                .font: UIFont.preferredFont(forTextStyle: .headline, weight: .medium)
            ],
            for: .normal
        )
        $0.setTitleTextAttributes(
            [
                NSAttributedString.Key.foregroundColor: UIColor.black,
                .font: UIFont.preferredFont(forTextStyle: .headline, weight: .semibold)
            ],
            for: .selected
        )
        $0.selectedSegmentIndex = 0
        $0.addTarget(self, action: #selector(changeValue(control:)), for: .valueChanged)
    }

    private let childView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private let vc1 = UserFeedViewController()
    private let vc2 = UserFeedViewController()

    private lazy var pageViewController: UIPageViewController = {
        let vc = UIPageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
        vc.setViewControllers([self.dataViewControllers[0]], direction: .forward, animated: true)
        vc.delegate = self
        vc.dataSource = self
        vc.view.translatesAutoresizingMaskIntoConstraints = false
        return vc
    }()

    var dataViewControllers: [UIViewController] {
        [vc1, vc2]
    }

    var currentPage: Int = 0 {
        didSet {
            let direction: UIPageViewController.NavigationDirection = oldValue <= self.currentPage ? .forward : .reverse
            self.pageViewController.setViewControllers(
                [dataViewControllers[self.currentPage]],
                direction: direction,
                animated: true,
                completion: nil
            )
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        changeValue(control: segmentedControl)
        if isOwn {
            userProfileView.followButton.isHidden = true
        } else {
            userProfileView.editButton.isHidden = true
        }
    }

    override func render() {
        view.addSubviews(userProfileView, segmentedControl, pageViewController.view)

        userProfileView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(100)
        }

        segmentedControl.snp.makeConstraints {
            $0.top.equalTo(userProfileView.snp.bottom)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(50)
        }

        pageViewController.view.snp.makeConstraints {
            $0.top.equalTo(segmentedControl.snp.bottom)
            $0.leading.trailing.bottom.equalToSuperview()
        }
    }

    override func setupNavigationBar() {
        super.setupNavigationBar()

        if isOwn {
            let userNicknameLabel = makeBarButtonItem(with: userNicknameLabel)
            let settingButton = makeBarButtonItem(with: settingButton)
            navigationItem.leftBarButtonItem = userNicknameLabel
            navigationItem.rightBarButtonItem = settingButton
        } else {
            let mapButton = makeBarButtonItem(with: mapButton)
            let optionButton = makeBarButtonItem(with: optionButton)
            navigationItem.rightBarButtonItems = [optionButton, mapButton]
            title = "coby5502"
        }
    }

    @objc private func changeValue(control: UISegmentedControl) {
        currentPage = control.selectedSegmentIndex
    }

    private func followUser() {
        userProfileView.followButton.isSelected = !userProfileView.followButton.isSelected
    }
}

extension ProfileViewController: UIPageViewControllerDataSource, UIPageViewControllerDelegate {
    func pageViewController(
        _: UIPageViewController,
        viewControllerBefore viewController: UIViewController
    ) -> UIViewController? {
        guard
            let index = dataViewControllers.firstIndex(of: viewController),
            index - 1 >= 0
        else { return nil }
        return dataViewControllers[index - 1]
    }

    func pageViewController(
        _: UIPageViewController,
        viewControllerAfter viewController: UIViewController
    ) -> UIViewController? {
        guard
            let index = dataViewControllers.firstIndex(of: viewController),
            index + 1 < dataViewControllers.count
        else { return nil }
        return dataViewControllers[index + 1]
    }

    func pageViewController(
        _ pageViewController: UIPageViewController,
        didFinishAnimating _: Bool,
        previousViewControllers _: [UIViewController],
        transitionCompleted _: Bool
    ) {
        guard
            let viewController = pageViewController.viewControllers?[0],
            let index = dataViewControllers.firstIndex(of: viewController)
        else { return }
        currentPage = index
        segmentedControl.selectedSegmentIndex = index
    }
}
