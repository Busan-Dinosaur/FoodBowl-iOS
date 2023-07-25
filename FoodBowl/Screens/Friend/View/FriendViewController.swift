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
        currentModalHeight = getModalHeight()
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
            $0.height.equalTo(getModalHeight())
        }
    }

    func getModalHeight() -> CGFloat {
        return UIScreen.main.bounds.height - getHeaderHeight() - 30
    }

    @objc
    func handlePan(_ gesture: UIPanGestureRecognizer) {
        guard gesture.view != nil else { return }
        let translation = gesture.translation(in: gesture.view?.superview)
        let minHeight: CGFloat = 200
        var newModalHeight = currentModalHeight - translation.y
        if newModalHeight > getModalHeight() {
            newModalHeight = getModalHeight()
        } else if newModalHeight < minHeight {
            newModalHeight = minHeight
        }
        modalView.snp.remakeConstraints {
            $0.top.equalTo(grabbarView.snp.bottom)
            $0.leading.trailing.bottom.equalToSuperview()
            $0.height.equalTo(newModalHeight)
        }
        if gesture.state == UIGestureRecognizer.State.ended {
            currentModalHeight = newModalHeight
        }
    }
}
