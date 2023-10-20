//
//  YPImagePicker+Extension.swift
//  FoodBowl
//
//  Created by COBY_PRO on 2023/01/23.
//

import UIKit

import SnapKit
import Then
import YPImagePicker

extension YPSelectionsGalleryVC {
    func makeBarButtonItem<T: UIView>(with view: T) -> UIBarButtonItem {
        return UIBarButtonItem(customView: view)
    }

    func removeBarButtonItemOffset(with button: UIButton, offsetX: CGFloat = 0, offsetY: CGFloat = 0) -> UIView {
        let offsetView = UIView(frame: CGRect(x: 0, y: 0, width: 45, height: 45))
        offsetView.bounds = offsetView.bounds.offsetBy(dx: offsetX, dy: offsetY)
        offsetView.addSubview(button)
        return offsetView
    }

    override open func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        if let controllersCount = navigationController?.viewControllers.count, controllersCount > 1 {
            lazy var backButton = BackButton().then {
                let buttonAction = UIAction { [weak self] _ in
                    self?.navigationController?.popViewController(animated: true)
                }
                $0.addAction(buttonAction, for: .touchUpInside)
            }

            let leftOffsetBackButton = removeBarButtonItemOffset(with: backButton, offsetX: 10)
            let backButtonView = makeBarButtonItem(with: leftOffsetBackButton)

            navigationItem.leftBarButtonItem = backButtonView
            title = "필터 선택"
        }
    }
}

extension YPPhotoFiltersVC {
    func makeBarButtonItem<T: UIView>(with view: T) -> UIBarButtonItem {
        return UIBarButtonItem(customView: view)
    }

    func removeBarButtonItemOffset(with button: UIButton, offsetX: CGFloat = 0, offsetY: CGFloat = 0) -> UIView {
        let offsetView = UIView(frame: CGRect(x: 0, y: 0, width: 45, height: 45))
        offsetView.bounds = offsetView.bounds.offsetBy(dx: offsetX, dy: offsetY)
        offsetView.addSubview(button)
        return offsetView
    }

    override open func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        if let controllersCount = navigationController?.viewControllers.count, controllersCount > 1 {
            lazy var backButton = BackButton().then {
                let buttonAction = UIAction { [weak self] _ in
                    self?.navigationController?.popViewController(animated: true)
                }
                $0.addAction(buttonAction, for: .touchUpInside)
            }

            let leftOffsetBackButton = removeBarButtonItemOffset(with: backButton, offsetX: 10)
            let backButtonView = makeBarButtonItem(with: leftOffsetBackButton)

            navigationItem.leftBarButtonItem = backButtonView
            title = "필터 선택"
        }
    }
}
