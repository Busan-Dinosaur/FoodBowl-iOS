//
//  AddFeedViewController.swift
//  FoodBowl
//
//  Created by Coby Kim on 2023/01/13.
//

import UIKit

import SnapKit
import Then

final class AddFeedViewController: BaseViewController {
    var newFeed = Feed(id: nil, store: nil, categories: nil, photoes: nil, comment: nil)

    private lazy var pageViewController = UIPageViewController(
        transitionStyle: .scroll,
        navigationOrientation: .horizontal,
        options: nil
    )

    private let vc1 = SetStoreViewController()
    private let vc2 = SetCategoryViewController()
    private let vc3 = SetPhotoViewController()
    private let vc4 = SetCommentViewController()

    lazy var dataViewControllers: [UIViewController] = {
        [vc1, vc2, vc3, vc4]
    }()

    private let pageControl = UIPageControl()

    private lazy var closeButton = CloseButton().then {
        let action = UIAction { [weak self] _ in
            self?.dismiss(animated: true, completion: nil)
        }
        $0.addAction(action, for: .touchUpInside)
    }

    private lazy var backButton = BackButton().then {
        let buttonAction = UIAction { [weak self] _ in
            self?.backPage()
        }
        $0.addAction(buttonAction, for: .touchUpInside)
    }

    private lazy var nextButton = UIButton().then {
        $0.setTitle("다음", for: .normal)
        $0.setTitleColor(.mainColor, for: .normal)
        $0.titleLabel?.font = UIFont.preferredFont(forTextStyle: .headline, weight: .regular)
        let buttonAction = UIAction { [weak self] _ in
            self?.nextPage()
        }
        $0.addAction(buttonAction, for: .touchUpInside)
    }

    private lazy var completeButton = UIButton().then {
        $0.setTitle("완료", for: .normal)
        $0.setTitleColor(.mainColor, for: .normal)
        $0.titleLabel?.font = UIFont.preferredFont(forTextStyle: .headline, weight: .regular)
        let buttonAction = UIAction { [weak self] _ in
            self?.completeAddFeed()
        }
        $0.addAction(buttonAction, for: .touchUpInside)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        pageControl.numberOfPages = dataViewControllers.count
        pageControl.currentPage = 0
    }

    override func setupLayout() {
        addChild(pageViewController)
        view.addSubviews(pageViewController.view)

        pageViewController.didMove(toParent: self)

        pageViewController.view.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }

    override func configureUI() {
        if let firstVC = dataViewControllers.first {
            pageViewController.setViewControllers([firstVC], direction: .forward, animated: true, completion: nil)
        }

        vc1.delegate = self
        vc2.delegate = self
        vc3.delegate = self
        vc4.delegate = self
        vc3.delegateForComment = vc4
    }

    override func setupNavigationBar() {
        super.setupNavigationBar()

        let leftOffsetCloseButton = removeBarButtonItemOffset(with: closeButton, offsetX: 10)
        let closeButton = makeBarButtonItem(with: leftOffsetCloseButton)
        let nextButton = makeBarButtonItem(with: nextButton)
        navigationItem.leftBarButtonItem = closeButton
        navigationItem.rightBarButtonItem = nextButton
        title = "가게 찾기"
    }

    private func updateNavigationBar(currentPage: Int) {
        let leftOffsetBackButton = removeBarButtonItemOffset(with: backButton, offsetX: 10)
        let backButton = makeBarButtonItem(with: leftOffsetBackButton)
        let leftOffsetCloseButton = removeBarButtonItemOffset(with: closeButton, offsetX: 10)
        let closeButton = makeBarButtonItem(with: leftOffsetCloseButton)
        let nextButton = makeBarButtonItem(with: nextButton)
        let completeButton = makeBarButtonItem(with: completeButton)

        switch currentPage {
        case 0:
            navigationItem.leftBarButtonItem = closeButton
            navigationItem.rightBarButtonItem = nextButton
            title = "가게 찾기"
        case 1:
            navigationItem.leftBarButtonItem = backButton
            navigationItem.rightBarButtonItem = nextButton
            title = "카테고리 선택"
        case 2:
            navigationItem.leftBarButtonItem = backButton
            navigationItem.rightBarButtonItem = nextButton
            title = "사진 등록"
        case 3:
            navigationItem.leftBarButtonItem = backButton
            navigationItem.rightBarButtonItem = completeButton
            title = "후기 작성"
        default:
            return
        }
    }

    private func backPage() {
        let currentPage = pageControl.currentPage
        let previousPage = currentPage - 1

        let previousVC = dataViewControllers[previousPage]
        pageViewController.setViewControllers([previousVC], direction: .reverse, animated: true) { _ in
            self.pageControl.currentPage = previousPage
        }

        updateNavigationBar(currentPage: previousPage)
    }

    private func nextPage() {
        let currentPage = pageControl.currentPage
        let nextPage = currentPage + 1

        switch currentPage {
        case 0:
            if newFeed.store == nil {
                showAlert(message: "가게를 선택해주세요")
                return
            }
        case 1:
            if newFeed.categories?.count == 0 {
                showAlert(message: "카테고리를 선택해주세요")
                return
            }
        case 2:
            if newFeed.photoes == nil {
                showAlert(message: "사진을 등록해주세요")
                return
            }
        default: ()
        }

        let nextVC = dataViewControllers[nextPage]
        pageViewController.setViewControllers([nextVC], direction: .forward, animated: true) { _ in
            self.pageControl.currentPage = nextPage
        }

        updateNavigationBar(currentPage: nextPage)
    }

    private func completeAddFeed() {
        print(newFeed)
        dismiss(animated: true, completion: nil)
    }

    private func showAlert(message: String) {
        let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        let cancel = UIAlertAction(title: "닫기", style: .cancel, handler: nil)

        alert.addAction(cancel)

        present(alert, animated: true, completion: nil)
    }
}

extension AddFeedViewController: SetStoreViewControllerDelegate, SetCategoryViewControllerDelegate,
    SetPhotoViewControllerDelegate,
    SetCommentViewControllerDelegate {
    func setStore(store: Place?) {
        newFeed.store = store
    }

    func setCategories(categories: [Category]?) {
        newFeed.categories = categories
    }

    func setPhotoes(photoes: [UIImage]?) {
        newFeed.photoes = photoes
    }

    func setComment(comment: String?) {
        newFeed.comment = comment
    }
}
