//
//  SetStoreViewController.swift
//  FoodBowl
//
//  Created by COBY_PRO on 2022/12/23.
//

import UIKit

import Alamofire
import SnapKit
import Then

final class SetStoreViewController: BaseViewController {
    var delegate: SetStoreViewControllerDelegate?
    var selectedStore: Place?
    var category: String?
    var univ: Place?

    // MARK: - property
    private let guideLabel = UILabel().then {
        $0.text = "후기를 작성할 가게를 찾아주세요."
        $0.font = UIFont.preferredFont(forTextStyle: .body, weight: .medium)
        $0.textColor = .mainText
    }

    lazy var searchBarButton = SearchBarButton().then {
        $0.placeholderLabel.text = "가게 검색"
        let action = UIAction { [weak self] _ in
            let searchStoreViewController = SearchStoreViewController()
            let navigationController = UINavigationController(rootViewController: searchStoreViewController)
            navigationController.modalPresentationStyle = .fullScreen
            searchStoreViewController.delegate = self
            DispatchQueue.main.async {
                self?.present(navigationController, animated: true)
            }
        }
        $0.addAction(action, for: .touchUpInside)
    }

    lazy var selectedStoreView = SelectedStoreView().then {
        $0.isHidden = true
    }

    // MARK: - life cycle
    override func setupLayout() {
        view.addSubviews(guideLabel, searchBarButton, selectedStoreView)

        guideLabel.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top).inset(20)
            $0.leading.equalToSuperview().inset(BaseSize.horizantalPadding)
        }

        searchBarButton.snp.makeConstraints {
            $0.top.equalTo(guideLabel.snp.bottom).offset(20)
            $0.leading.trailing.equalToSuperview().inset(BaseSize.horizantalPadding)
            $0.height.equalTo(40)
        }

        selectedStoreView.snp.makeConstraints {
            $0.top.equalTo(searchBarButton.snp.bottom).offset(10)
            $0.leading.trailing.equalToSuperview().inset(BaseSize.horizantalPadding)
            $0.height.equalTo(60)
        }
    }

    private func searchUniv() {
        let url = "https://dapi.kakao.com/v2/local/search/keyword"

        let headers: HTTPHeaders = [
            "Content-Type": "application/x-www-form-urlencoded;charset=utf-8",
            "Authorization": "KakaoAK 855a5bf7cbbe725de0f5b6474fe8d6db"
        ]

        let parameters: [String: Any] = [
            "query": "대학교",
            "x": selectedStore!.longitude,
            "y": selectedStore!.latitude,
            "page": 1,
            "size": 1,
            "radius": 3000,
            "category_group_code": "SC4"
        ]

        AF.request(
            url,
            method: .get,
            parameters: parameters,
            encoding: URLEncoding.default,
            headers: headers
        )
        .responseDecodable(of: PlaceResponse.self) { response in
            switch response.result {
            case .success(let data):
                if data.documents.count > 0 {
                    self.univ = data.documents[0]
                }
            case .failure(let error):
                print("Request failed with error: \(error)")
            }
        }
    }

    func getCategory() {
        let categoryName = selectedStore!.categoryName
            .components(separatedBy: ">").map { $0.trimmingCharacters(in: .whitespaces) }
        let categories = Category.allCases.map { $0.rawValue }
        if categories.contains(categoryName[1]) == true {
            category = categoryName[1]
            let subCategory: String? = categoryName[2]
            if subCategory == "해물,생선" {
                category = "해산물"
            }
        } else {
            category = "기타"
        }
    }
}

extension SetStoreViewController: SearchStoreViewControllerDelegate {
    func setStore(store: Place, category: String) {
        selectedStore = store
        searchBarButton.placeholderLabel.text = "가게 재검색"
        selectedStoreView.storeNameLabel.text = selectedStore?.placeName
        selectedStoreView.storeAdressLabel.text = selectedStore?.addressName
        selectedStoreView.isHidden = false

        let action = UIAction { [weak self] _ in
            let showWebViewController = ShowWebViewController()
            showWebViewController.title = "가게 정보"
            showWebViewController.url = self?.selectedStore?.placeURL ?? ""
            let navigationController = UINavigationController(rootViewController: showWebViewController)
            navigationController.modalPresentationStyle = .fullScreen
            DispatchQueue.main.async {
                self?.present(navigationController, animated: true)
            }
        }
        selectedStoreView.mapButton.addAction(action, for: .touchUpInside)
        searchUniv()
        getCategory()

        delegate?.setStore(store: selectedStore, univ: univ, category: category)
    }
}

protocol SetStoreViewControllerDelegate: AnyObject {
    func setStore(store: Place?, univ: Place?, category: String?)
}
