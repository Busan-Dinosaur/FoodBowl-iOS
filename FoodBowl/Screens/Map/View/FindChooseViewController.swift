//
//  FindViewController.swift
//  FoodBowl
//
//  Created by COBY_PRO on 2023/07/24.
//

import UIKit

import SnapKit
import Then

final class FindViewController: BaseViewController {
    private lazy var searchBar = UISearchBar().then {
        $0.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width - 80, height: 0)
        $0.placeholder = "가게 이름을 검색해주세요"
    }

    private lazy var cancelButton = UIButton().then {
        $0.setTitle("취소", for: .normal)
        $0.setTitleColor(.mainPink, for: .normal)
        $0.titleLabel?.font = UIFont.preferredFont(forTextStyle: .headline, weight: .regular)
        let buttonAction = UIAction { [weak self] _ in
            self?.dismiss(animated: true, completion: nil)
        }
        $0.addAction(buttonAction, for: .touchUpInside)
    }

    private lazy var segmentedControl = UnderlineSegmentedControl(items: ["맛집", "유저"]).then {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.subText], for: .normal)
        $0.setTitleTextAttributes(
            [
                NSAttributedString.Key.foregroundColor: UIColor.mainText,
                .font: UIFont.preferredFont(forTextStyle: .subheadline, weight: .medium)
            ],
            for: .selected
        )
        $0.addTarget(self, action: #selector(changeValue(control:)), for: .valueChanged)
        $0.selectedSegmentIndex = 0
    }

    private let vc1 = FindStoreViewController()

    private let vc2 = FindUserViewController()

    private lazy var pageViewController = UIPageViewController(
        transitionStyle: .scroll,
        navigationOrientation: .horizontal,
        options: nil
    ).then {
        $0.setViewControllers([self.dataViewControllers[0]], direction: .forward, animated: true)
        $0.delegate = self
        $0.dataSource = self
        $0.view.translatesAutoresizingMaskIntoConstraints = false
    }

    private var dataViewControllers: [UIViewController] {
        [vc1, vc2]
    }

    private var currentPage: Int = 0 {
        didSet {
            // from segmentedControl -> pageViewController 업데이트
            print(oldValue, self.currentPage)
            let direction: UIPageViewController.NavigationDirection = oldValue <= self.currentPage ? .forward : .reverse
            self.pageViewController.setViewControllers(
                [dataViewControllers[self.currentPage]],
                direction: direction,
                animated: true,
                completion: nil
            )
        }
    }

    override func setupLayout() {
        view.addSubviews(segmentedControl, pageViewController.view)

        segmentedControl.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview()
            $0.top.equalToSuperview().inset(100)
            $0.height.equalTo(40)
        }

        pageViewController.view.snp.makeConstraints {
            $0.top.equalTo(segmentedControl.snp.bottom)
            $0.leading.trailing.bottom.equalToSuperview()
        }
    }

    override func configureUI() {
        super.configureUI()
        changeValue(control: segmentedControl)
    }

    override func setupNavigationBar() {
        let cancelButton = makeBarButtonItem(with: cancelButton)
        navigationItem.rightBarButtonItem = cancelButton
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: searchBar)
    }

    @objc
    private func changeValue(control: UISegmentedControl) {
        currentPage = control.selectedSegmentIndex
    }
}

extension FindViewController: UIPageViewControllerDataSource, UIPageViewControllerDelegate {
    func pageViewController(
        _ pageViewController: UIPageViewController,
        viewControllerBefore viewController: UIViewController
    ) -> UIViewController? {
        guard let index = dataViewControllers.firstIndex(of: viewController),
              index - 1 >= 0
        else { return nil }
        return dataViewControllers[index - 1]
    }

    func pageViewController(
        _ pageViewController: UIPageViewController,
        viewControllerAfter viewController: UIViewController
    ) -> UIViewController? {
        guard let index = dataViewControllers.firstIndex(of: viewController),
              index + 1 < dataViewControllers.count
        else { return nil }
        return dataViewControllers[index + 1]
    }

    func pageViewController(
        _ pageViewController: UIPageViewController,
        didFinishAnimating finished: Bool,
        previousViewControllers: [UIViewController],
        transitionCompleted completed: Bool
    ) {
        guard let viewController = pageViewController.viewControllers?[0],
              let index = dataViewControllers.firstIndex(of: viewController)
        else { return }
        currentPage = index
        segmentedControl.selectedSegmentIndex = index
    }
}
