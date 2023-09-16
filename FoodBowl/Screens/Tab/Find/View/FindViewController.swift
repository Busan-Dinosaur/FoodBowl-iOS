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
    let findGuideLabel = PaddingLabel().then {
        $0.font = .font(.regular, ofSize: 22)
        $0.text = "찾기"
        $0.textColor = .mainText
        $0.padding = UIEdgeInsets(top: 0, left: 4, bottom: 0, right: 0)
        $0.frame = CGRect(x: 0, y: 0, width: 150, height: 0)
    }

    // MARK: - property
    private lazy var searchController = UISearchController(searchResultsController: nil).then {
        $0.searchBar.placeholder = "검색"
        $0.searchBar.scopeButtonTitles = ["맛집", "유저"]
        $0.searchResultsUpdater = self
        $0.searchBar.showsScopeBar = true
    }

    private lazy var segmentedControl = UnderlineSegmentedControl(items: ["맛집", "유저"]).then {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.setTitleTextAttributes(
            [
                NSAttributedString.Key.foregroundColor: UIColor.subText,
                .font: UIFont.preferredFont(forTextStyle: .subheadline, weight: .regular)
            ],
            for: .normal
        )
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

    private var dataViewControllers: [UIViewController] {
        [vc1, vc2]
    }

    private lazy var pageViewController = UIPageViewController(
        transitionStyle: .scroll,
        navigationOrientation: .horizontal,
        options: nil
    ).then {
        $0.setViewControllers([self.dataViewControllers[0]], direction: .forward, animated: true)
        $0.delegate = self
        $0.dataSource = self
    }

    private var currentPage: Int = 0 {
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

    override func setupLayout() {
        view.addSubviews(pageViewController.view)

        pageViewController.view.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide)
            $0.leading.trailing.bottom.equalToSuperview()
        }
    }

    override func configureUI() {
        super.configureUI()
        changeValue(control: segmentedControl)
        vc1.delegate = self
        vc2.delegate = self
    }

    override func setupNavigationBar() {
        super.setupNavigationBar()
        let findGuideLabel = makeBarButtonItem(with: findGuideLabel)
        let plusButton = makeBarButtonItem(with: plusButton)
        navigationItem.leftBarButtonItem = findGuideLabel
        navigationItem.rightBarButtonItem = plusButton
        navigationItem.searchController = searchController
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

extension FindViewController: FindStoreViewControllerDelegate, FindUserViewControllerDelegate {
    func setStore(storeDetailViewController: StoreDetailViewController) {
        navigationController?.pushViewController(storeDetailViewController, animated: true)
    }

    func setUser(profileViewController: ProfileViewController) {
        navigationController?.pushViewController(profileViewController, animated: true)
    }
}

extension FindViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        guard let text = searchController.searchBar.text?.lowercased() else { return }
    }
}
