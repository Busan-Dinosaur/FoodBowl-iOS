//
//  SearchStoreViewController.swift
//  FoodBowl
//
//  Created by COBY_PRO on 2022/12/23.
//

import UIKit

import Alamofire
import SnapKit
import Then

final class SearchStoreViewController: BaseViewController {
    var delegate: SearchStoreViewControllerDelegate?

    private var stores = [Place]()

    // MARK: - property

    private lazy var searchBar = UISearchBar().then {
        $0.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width - 80, height: 0)
        $0.placeholder = "가게 이름을 검색해주세요"
        $0.delegate = self
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

    private lazy var storeInfoTableView = UITableView().then {
        $0.register(StoreInfoTableViewCell.self, forCellReuseIdentifier: StoreInfoTableViewCell.className)
        $0.delegate = self
        $0.dataSource = self
        $0.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 20, right: 0)
        $0.backgroundColor = .clear
    }

    // MARK: - life cycle

    override func render() {
        view.addSubviews(storeInfoTableView)

        storeInfoTableView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }

    override func setupNavigationBar() {
        let cancelButton = makeBarButtonItem(with: cancelButton)
        navigationItem.rightBarButtonItem = cancelButton
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: searchBar)
    }

    private func searchStores(keyword: String) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }

        let url = "https://dapi.kakao.com/v2/local/search/keyword"

        let headers: HTTPHeaders = [
            "Content-Type": "application/x-www-form-urlencoded;charset=utf-8",
            "Authorization": "KakaoAK 855a5bf7cbbe725de0f5b6474fe8d6db"
        ]

        let parameters: [String: Any] = [
            "query": keyword,
            "x": String(appDelegate.currentLoc.coordinate.longitude),
            "y": String(appDelegate.currentLoc.coordinate.latitude),
            "page": 1,
            "size": 15
        ]

        AF.request(url,
                   method: .get,
                   parameters: parameters,
                   encoding: URLEncoding.default,
                   headers: headers)
            .responseDecodable(of: Response.self) { response in
                switch response.result {
                case let .success(data):
                    self.stores = data.documents
                    self.storeInfoTableView.reloadData()
                case let .failure(error):
                    print("Request failed with error: \(error)")
                }
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
        cell.storeAdressLabel.text = stores[indexPath.item].addressName
        cell.storeDistanceLabel.text = stores[indexPath.item].distance.prettyDistance

        return cell
    }

    func tableView(_: UITableView, heightForRowAt _: IndexPath) -> CGFloat {
        return 60
    }

    func tableView(_: UITableView, didSelectRowAt indexPath: IndexPath) {
        delegate?.setStore(store: stores[indexPath.item])
        dismiss(animated: true, completion: nil)
    }
}

extension SearchStoreViewController: UISearchBarDelegate {
    private func dissmissKeyboard() {
        searchBar.resignFirstResponder()
    }

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        dissmissKeyboard()
        guard let searchTerm = searchBar.text, searchTerm.isEmpty == false else { return }
        searchStores(keyword: searchTerm)
    }
}

extension String {
    var prettyDistance: String {
        guard let distance = Double(self) else { return "" }
        guard distance > -.infinity else { return "?" }
        let formatter = LengthFormatter()
        formatter.numberFormatter.maximumFractionDigits = 1
        if distance >= 1000 {
            return formatter.string(fromValue: distance / 1000, unit: LengthFormatter.Unit.kilometer)
        } else {
            let value = Double(Int(distance)) // 미터로 표시할 땐 소수점 제거
            return formatter.string(fromValue: value, unit: LengthFormatter.Unit.meter)
        }
    }
}
