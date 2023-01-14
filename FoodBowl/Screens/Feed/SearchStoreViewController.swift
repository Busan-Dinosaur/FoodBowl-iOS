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
    }

    // MARK: - life cycle

    override func render() {
        view.addSubviews(storeInfoTableView)

        storeInfoTableView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }

    override func setupNavigationBar() {
        let searchBar = UISearchBar(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width - 80, height: 0))
        searchBar.placeholder = "가게 이름을 검색해주세요."
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: searchBar)

        let cancelButton = makeBarButtonItem(with: cancelButton)
        navigationItem.rightBarButtonItem = cancelButton
    }

    private func searchStores(keyword: String) {
        let url = "https://dapi.kakao.com/v2/local/search/keyword"

        let headers: HTTPHeaders = [
            "Content-Type": "application/x-www-form-urlencoded;charset=utf-8",
            "Authorization": "KakaoAK 855a5bf7cbbe725de0f5b6474fe8d6db"
        ]

        let parameters: [String: Any] = [
            "query": keyword,
            //            "x": 1,
            //            "y": 15,
            "page": 1,
            "size": 15
        ]

        AF.request(url,
                   method: .get,
                   parameters: parameters,
                   encoding: URLEncoding.default,
                   headers: headers)
            .validate(statusCode: 200 ..< 300)
            .responseJSON { response in
                // 여기서 가져온 데이터를 자유롭게 활용하세요.
                switch response.result {
                case let .success(res):
                    let resultData = String(data: response.data!, encoding: .utf8)

                    do {
                        // 반환값을 Data 타입으로 변환
                        let jsonData = try JSONSerialization.data(withJSONObject: res, options: .prettyPrinted)
                        let json = try JSONDecoder().decode(Response.self, from: jsonData)
                        self.stores = json.documents

                        print(self.stores)
                        self.storeInfoTableView.reloadData()
                    } catch {
                        print("catch error : \(error.localizedDescription)")
                    }
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

        return cell
    }

    func tableView(_: UITableView, heightForRowAt _: IndexPath) -> CGFloat {
        return 70
    }

    func tableView(_: UITableView, didSelectRowAt _: IndexPath) {
        //        delegate?.setStore(store: stores[indexPath.item])
        dismiss(animated: true, completion: nil)
    }
}
