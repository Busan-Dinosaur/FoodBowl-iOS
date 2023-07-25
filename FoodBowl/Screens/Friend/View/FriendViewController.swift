//
//  FriendViewController.swift
//  FoodBowl
//
//  Created by COBY_PRO on 2023/07/18.
//

import UIKit

import SnapKit
import Then

final class FriendViewController: MapViewController {
    var panGesture = UIPanGestureRecognizer()

    let grabbarView = GrabbarView()
    let modalView = FriendFeedView()

    var currentModalHeight: CGFloat = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePan(_:)))
        grabbarView.isUserInteractionEnabled = true
        grabbarView.addGestureRecognizer(panGesture)
        currentModalHeight = getModalMaxHeight()
    }

    override func setupLayout() {
        super.setupLayout()
        view.addSubviews(grabbarView, modalView)

        grabbarView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(30)
        }

        modalView.snp.makeConstraints {
            $0.top.equalTo(grabbarView.snp.bottom)
            $0.leading.trailing.bottom.equalToSuperview()
            $0.height.equalTo(getModalMaxHeight())
        }
    }

    func getModalMaxHeight() -> CGFloat {
        return UIScreen.main.bounds.height - getHeaderHeight() - 30
    }

    @objc
    func handlePan(_ gesture: UIPanGestureRecognizer) {
        guard gesture.view != nil else { return }
        let translation = gesture.translation(in: gesture.view?.superview)
        let tabBarHeight: CGFloat = tabBarController?.tabBar.frame.height ?? 0
        let minHeight: CGFloat = tabBarHeight - 20
        let midHeight: CGFloat = UIScreen.main.bounds.height / 2 - 50
        let maxHeight: CGFloat = getModalMaxHeight()

        var newModalHeight = currentModalHeight - translation.y
        if newModalHeight < minHeight {
            newModalHeight = minHeight
            modalView.showResult()
            tabBarController?.tabBar.frame.origin = CGPoint(x: 0, y: UIScreen.main.bounds.maxY)
        } else if newModalHeight > maxHeight {
            newModalHeight = maxHeight
            modalView.showContent()
            tabBarController?.tabBar.frame.origin = CGPoint(x: 0, y: UIScreen.main.bounds.maxY - tabBarHeight)
        } else {
            modalView.showContent()
            tabBarController?.tabBar.frame.origin = CGPoint(x: 0, y: UIScreen.main.bounds.maxY - tabBarHeight)
        }

        modalView.snp.remakeConstraints {
            $0.top.equalTo(grabbarView.snp.bottom)
            $0.leading.trailing.bottom.equalToSuperview()
            $0.height.equalTo(newModalHeight)
        }

        if gesture.state == .ended {
            switch newModalHeight {
            case let height where height - minHeight < midHeight - height:
                currentModalHeight = minHeight
                modalView.showResult()
                tabBarController?.tabBar.frame.origin = CGPoint(x: 0, y: UIScreen.main.bounds.maxY)
            case let height where height - midHeight < maxHeight - height:
                currentModalHeight = midHeight
                modalView.showContent()
                tabBarController?.tabBar.frame.origin = CGPoint(x: 0, y: UIScreen.main.bounds.maxY - tabBarHeight)
            default:
                currentModalHeight = maxHeight
                modalView.showContent()
                tabBarController?.tabBar.frame.origin = CGPoint(x: 0, y: UIScreen.main.bounds.maxY - tabBarHeight)
            }

            modalView.snp.remakeConstraints {
                $0.top.equalTo(grabbarView.snp.bottom)
                $0.leading.trailing.bottom.equalToSuperview()
                $0.height.equalTo(currentModalHeight)
            }
        }
    }
}
