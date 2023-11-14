//
//  ImageViewController.swift
//  FoodBowl
//
//  Created by COBY_PRO on 10/18/23.
//

import UIKit

import SnapKit
import Then

final class ImageViewController: UIViewController {
    let imageScrollView = PanZoomImageView()

    lazy var closeButton = CloseButton().then {
        let action = UIAction { [weak self] _ in
            DispatchQueue.main.async {
                self?.dismiss(animated: true)
            }
        }
        $0.addAction(action, for: .touchUpInside)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupLayout()
        configureUI()
    }

    func setupLayout() {
        view.addSubviews(imageScrollView, closeButton)

        imageScrollView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }

        closeButton.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top).inset(SizeLiteral.horizantalPadding)
            $0.trailing.equalToSuperview().inset(SizeLiteral.horizantalPadding)
        }
    }

    func configureUI() {
        view.backgroundColor = .black
    }
}
