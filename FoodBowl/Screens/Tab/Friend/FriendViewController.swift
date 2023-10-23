//
//  FriendViewController.swift
//  FoodBowl
//
//  Created by COBY_PRO on 2023/07/18.
//

import Combine
import UIKit

import SnapKit
import Then

final class FriendViewController: MapViewController {
    
    // MARK: - ui component

    private let logoLabel = PaddingLabel().then {
        $0.font = .font(.regular, ofSize: 22)
        $0.textColor = .mainTextColor
        $0.text = "친구들"
        $0.padding = UIEdgeInsets(top: 0, left: 4, bottom: 0, right: 0)
        $0.frame = CGRect(x: 0, y: 0, width: 150, height: 0)
    }
    
    // MARK: - property
    
    private var cancelBag: Set<AnyCancellable> = Set()
    
    // MARK: - init
    
    deinit {
        print("\(#file) is dead")
    }
    
    // MARK: - life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureUI()
        self.setupNavigationBar()
    }

    override func configureUI() {
        super.configureUI()
        bookmarkButton.isHidden = false
    }

    private func setupNavigationBar() {
        let logoLabel = makeBarButtonItem(with: logoLabel)
        let plusButton = makeBarButtonItem(with: plusButton)
        navigationItem.leftBarButtonItem = logoLabel
        navigationItem.rightBarButtonItem = plusButton
    }
}
