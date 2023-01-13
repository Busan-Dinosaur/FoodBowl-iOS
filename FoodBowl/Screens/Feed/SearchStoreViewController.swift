//
//  SearchStoreViewController.swift
//  FoodBowl
//
//  Created by COBY_PRO on 2022/12/23.
//

import UIKit

import SnapKit
import Then

final class SearchStoreViewController: BaseViewController {
    // MARK: - property
    
    private lazy var cancelButton = UIButton().then {
        $0.setTitle("취소", for: .normal)
        $0.setTitleColor(.mainPink, for: .normal)
        $0.titleLabel?.font = UIFont.preferredFont(forTextStyle: .headline, weight: .regular)
        let buttonAction = UIAction { [weak self] _ in
            self?.dismiss(animated: true, completion: nil)
        }
        $0.addAction(buttonAction, for: .touchUpInside)
    }
    
    private lazy var searchField = UITextField().then {
        let attributes = [
            NSAttributedString.Key.foregroundColor : UIColor.grey001,
            NSAttributedString.Key.font : UIFont.preferredFont(forTextStyle: .body, weight: .medium)
        ]
        
        $0.backgroundColor = .white
        $0.attributedPlaceholder = NSAttributedString(string: "가게 검색", attributes: attributes)
        $0.autocapitalizationType = .none
        $0.layer.masksToBounds = true
        $0.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 0))
        $0.leftViewMode = .always
        $0.clipsToBounds = false
        $0.textColor = .subText
        $0.makeBorderLayer(color: .grey002)
    }

    // MARK: - life cycle

    override func render() {
        view.addSubviews(cancelButton, searchField)
        
        cancelButton.snp.makeConstraints {
            $0.top.equalToSuperview().inset(20)
            $0.trailing.equalToSuperview().inset(10)
            $0.width.height.equalTo(40)
        }
        
        searchField.snp.makeConstraints {
            $0.top.leading.equalToSuperview().inset(20)
            $0.trailing.equalTo(cancelButton.snp.leading).offset(-10)
            $0.height.equalTo(40)
        }
    }
}
