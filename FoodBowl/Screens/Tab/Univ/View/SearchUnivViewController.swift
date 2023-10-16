//
//  SearchUnivViewController.swift
//  FoodBowl
//
//  Created by COBY_PRO on 2023/09/18.
//

import UIKit

import SnapKit
import Then

final class SearchUnivViewController: BaseViewController {
    var delegate: SearchUnivViewControllerDelegate?

    private var viewModel = UnivViewModel()

    private var schools = [School]()
    private var filteredSchools = [School]()

    // MARK: - property
    private lazy var searchBar = UISearchBar().then {
        $0.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width - 80, height: 0)
        $0.placeholder = "검색"
        $0.delegate = self
    }

    private lazy var closeButton = UIButton().then {
        $0.setTitle("닫기", for: .normal)
        $0.setTitleColor(.mainPink, for: .normal)
        $0.titleLabel?.font = UIFont.preferredFont(forTextStyle: .headline, weight: .regular)
        let action = UIAction { [weak self] _ in
            self?.dismiss(animated: true)
        }
        $0.addAction(action, for: .touchUpInside)
    }

    private lazy var univTableView = UITableView().then {
        $0.register(StoreSearchTableViewCell.self, forCellReuseIdentifier: StoreSearchTableViewCell.className)
        $0.delegate = self
        $0.dataSource = self
        $0.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 20, right: 0)
        $0.backgroundColor = .clear
    }

    // MARK: - life cycle
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        Task {
            await schools = viewModel.getSchools()
            filteredSchools = schools
            univTableView.reloadData()
        }
    }

    override func setupLayout() {
        view.addSubviews(univTableView)

        univTableView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }

    override func setupNavigationBar() {
        let closeButton = makeBarButtonItem(with: closeButton)
        navigationItem.rightBarButtonItem = closeButton
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: searchBar)
    }

    private func setUniv(univ: School) {
        delegate?.setUniv(univ: univ)
        dismiss(animated: true)
    }
}

extension SearchUnivViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_: UITableView, numberOfRowsInSection _: Int) -> Int {
        return filteredSchools.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView
            .dequeueReusableCell(withIdentifier: StoreSearchTableViewCell.className, for: indexPath) as? StoreSearchTableViewCell
        else { return UITableViewCell() }

        cell.selectionStyle = .none
        cell.storeNameLabel.text = filteredSchools[indexPath.item].name
        cell.storeAdressLabel.text = filteredSchools[indexPath.item].address
        cell.storeDistanceLabel.text = filteredSchools[indexPath.item].distance

        return cell
    }

    func tableView(_: UITableView, heightForRowAt _: IndexPath) -> CGFloat {
        return 60
    }

    func tableView(_: UITableView, didSelectRowAt indexPath: IndexPath) {
        setUniv(univ: filteredSchools[indexPath.item])
    }
}

extension SearchUnivViewController: UISearchBarDelegate {
    private func dissmissKeyboard() {
        searchBar.resignFirstResponder()
    }

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        dissmissKeyboard()
    }

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText == "" {
            filteredSchools = schools
        } else {
            filteredSchools = schools.filter { $0.name.contains(searchText) }
        }
        univTableView.reloadData()
    }
}

protocol SearchUnivViewControllerDelegate: AnyObject {
    func setUniv(univ: School)
}
