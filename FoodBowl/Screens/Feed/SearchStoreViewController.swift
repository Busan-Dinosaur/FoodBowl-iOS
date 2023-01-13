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
    
    let stores = [Place(placeName: "틈새라면", address: "묵호동 102-2412415"), Place(placeName: "틈새라면", address: "묵호동 102-2412415"), Place(placeName: "틈새라면", address: "묵호동 102-2412415")]
    
    var delegate: SearchStoreViewControllerDelegate?
    
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
        
        $0.backgroundColor = .grey003
        $0.attributedPlaceholder = NSAttributedString(string: "가게 검색", attributes: attributes)
        $0.autocapitalizationType = .none
        $0.layer.masksToBounds = true
        $0.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 0))
        $0.leftViewMode = .always
        $0.clipsToBounds = false
        $0.layer.cornerRadius = 10
        $0.clearButtonMode = .whileEditing
        $0.textColor = .subText
    }
    
    private lazy var storeInfoTableView = UITableView().then {
        $0.register(StoreInfoTableViewCell.self, forCellReuseIdentifier: StoreInfoTableViewCell.className)
        $0.delegate = self
        $0.dataSource = self
        $0.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 20, right: 0)
    }

    // MARK: - life cycle

    override func render() {
        view.addSubviews(cancelButton, searchField, storeInfoTableView)
        
        cancelButton.snp.makeConstraints {
            $0.top.equalToSuperview().inset(10)
            $0.trailing.equalToSuperview().inset(10)
            $0.width.height.equalTo(40)
        }
        
        searchField.snp.makeConstraints {
            $0.top.equalToSuperview().inset(10)
            $0.leading.equalToSuperview().inset(20)
            $0.trailing.equalTo(cancelButton.snp.leading).offset(-10)
            $0.height.equalTo(40)
        }
        
        storeInfoTableView.snp.makeConstraints {
            $0.top.equalTo(searchField.snp.bottom).offset(10)
            $0.leading.trailing.bottom.equalToSuperview()
        }
    }
}

extension SearchStoreViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_: UITableView, numberOfRowsInSection _: Int) -> Int {
        return stores.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: StoreInfoTableViewCell.className, for: indexPath) as? StoreInfoTableViewCell else { return UITableViewCell() }
        
        cell.selectionStyle = .none
        cell.storeNameLabel.text = stores[indexPath.item].placeName
        cell.storeAdressLabel.text = stores[indexPath.item].address
        
        return cell
    }
    
    func tableView(_: UITableView, heightForRowAt _: IndexPath) -> CGFloat {
        return 70
    }
    
    func tableView(_: UITableView, didSelectRowAt indexPath: IndexPath) {
        delegate?.setStore(store: stores[indexPath.item])
        dismiss(animated: true, completion: nil)
    }
}
