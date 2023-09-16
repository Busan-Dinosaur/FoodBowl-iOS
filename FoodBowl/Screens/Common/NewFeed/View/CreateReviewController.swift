//
//  CreateReviewController.swift
//  FoodBowl
//
//  Created by COBY_PRO on 2023/09/16.
//

import UIKit

import SnapKit
import Then
import YPImagePicker

final class CreateReviewController: BaseViewController {
    private enum Size {
        static let cellWidth: CGFloat = 100
        static let cellHeight: CGFloat = cellWidth
        static let collectionInset = UIEdgeInsets(
            top: 0,
            left: 20,
            bottom: 0,
            right: 20
        )
    }

    private let textViewPlaceHolder = "100자 이내"

    private var stores = [Place]()

    private var viewModel = CreateReviewViewModel()

    private let newFeedGuideLabel = PaddingLabel().then {
        $0.font = .font(.regular, ofSize: 22)
        $0.text = "후기 작성"
        $0.textColor = .mainText
        $0.padding = UIEdgeInsets(top: 0, left: 4, bottom: 0, right: 0)
        $0.frame = CGRect(x: 0, y: 0, width: 150, height: 0)
    }

    private lazy var resultsStoreTableViewController = ResultsStoreTableViewController().then {
        $0.storeInfoTableView.delegate = self
        $0.storeInfoTableView.dataSource = self
    }

    private lazy var searchController = UISearchController(searchResultsController: resultsStoreTableViewController).then {
        $0.searchBar.placeholder = "맛집 검색"
        $0.searchResultsUpdater = self
        $0.searchBar.setValue("취소", forKey: "cancelButtonText")
        $0.searchBar.tintColor = .mainPink
    }

    private lazy var selectedStoreView = SelectedStoreView().then {
        $0.isHidden = true
    }

    private let guidePhotoLabel = UILabel().then {
        $0.text = "음식 사진을 등록해주세요."
        $0.font = UIFont.preferredFont(forTextStyle: .body, weight: .medium)
        $0.textColor = .mainText
    }

    private let collectionViewFlowLayout = UICollectionViewFlowLayout().then {
        $0.scrollDirection = .horizontal
        $0.sectionInset = Size.collectionInset
        $0.itemSize = CGSize(width: Size.cellWidth, height: Size.cellHeight)
        $0.minimumInteritemSpacing = 4
    }

    private lazy var listCollectionView = UICollectionView(frame: .zero, collectionViewLayout: collectionViewFlowLayout).then {
        $0.dataSource = self
        $0.delegate = self
        $0.showsVerticalScrollIndicator = false
        $0.register(PhotoPlusCollectionViewCell.self, forCellWithReuseIdentifier: PhotoPlusCollectionViewCell.className)
        $0.register(PhotoCollectionViewCell.self, forCellWithReuseIdentifier: PhotoCollectionViewCell.className)
        $0.backgroundColor = .clear
        $0.showsHorizontalScrollIndicator = false
    }

    private let guideCommentLabel = UILabel().then {
        $0.text = "후기를 작성해주세요."
        $0.font = UIFont.preferredFont(forTextStyle: .body, weight: .medium)
        $0.textColor = .mainText
    }

    lazy var commentTextView = UITextView().then {
        $0.textContainerInset = UIEdgeInsets(top: 12, left: 10, bottom: 12, right: 10)
        $0.font = UIFont.preferredFont(forTextStyle: .subheadline, weight: .light)
        $0.textAlignment = NSTextAlignment.left
        $0.dataDetectorTypes = UIDataDetectorTypes.all
        $0.text = textViewPlaceHolder
        $0.textColor = .grey001
        $0.isEditable = true
        $0.delegate = self
        $0.isScrollEnabled = true
        $0.isUserInteractionEnabled = true
        $0.makeBorderLayer(color: .grey002)
        $0.backgroundColor = .clear
    }

    private lazy var completeButton = MainButton().then {
        $0.label.text = "완료"
        let action = UIAction { [weak self] _ in
            self?.tappedCompleteButton()
        }
        $0.addAction(action, for: .touchUpInside)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }

    override func setupLayout() {
        view.addSubviews(
            selectedStoreView,
            guidePhotoLabel,
            listCollectionView,
            guideCommentLabel,
            commentTextView,
            completeButton
        )

        selectedStoreView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide)
            $0.leading.trailing.equalToSuperview().inset(BaseSize.horizantalPadding)
            $0.height.equalTo(0)
        }

        guidePhotoLabel.snp.makeConstraints {
            $0.top.equalTo(selectedStoreView.snp.bottom).offset(40)
            $0.leading.equalToSuperview().inset(BaseSize.horizantalPadding)
        }

        listCollectionView.snp.makeConstraints {
            $0.top.equalTo(guidePhotoLabel.snp.bottom).offset(10)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(100)
        }

        guideCommentLabel.snp.makeConstraints {
            $0.top.equalTo(listCollectionView.snp.bottom).offset(40)
            $0.leading.equalToSuperview().inset(BaseSize.horizantalPadding)
        }

        commentTextView.snp.makeConstraints {
            $0.top.equalTo(guideCommentLabel.snp.bottom).offset(10)
            $0.leading.trailing.equalToSuperview().inset(BaseSize.horizantalPadding)
            $0.height.equalTo(100)
        }

        completeButton.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(BaseSize.horizantalPadding)
            $0.bottom.equalTo(view.safeAreaLayoutGuide).inset(BaseSize.bottomPadding)
            $0.height.equalTo(60)
        }
    }

    override func setupNavigationBar() {
        super.setupNavigationBar()
        let newFeedGuideLabel = makeBarButtonItem(with: newFeedGuideLabel)
        let closeButton = makeBarButtonItem(with: closeButton)
        navigationItem.leftBarButtonItem = newFeedGuideLabel
        navigationItem.rightBarButtonItem = closeButton
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
    }

    private func photoAddButtonDidTap() {
        var config = YPImagePickerConfiguration()
        config.onlySquareImagesFromCamera = true
        config.library.maxNumberOfItems = 4 // 최대 선택 가능한 사진 개수 제한
        config.library.minNumberOfItems = 0
        config.library.mediaType = .photo // 미디어타입(사진, 사진/동영상, 동영상)
        config.startOnScreen = YPPickerScreen.library
        config.shouldSaveNewPicturesToAlbum = true
        config.albumName = "FoodBowl"

        let titleAttributes = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 17, weight: .regular)]
        let barButtonAttributes = [NSAttributedString.Key.font: UIFont.preferredFont(forTextStyle: .headline, weight: .regular)]
        UINavigationBar.appearance().titleTextAttributes = titleAttributes // Title fonts
        UIBarButtonItem.appearance().setTitleTextAttributes(barButtonAttributes, for: .normal) // Bar Button fonts
        config.wordings.libraryTitle = "갤러리"
        config.wordings.cameraTitle = "카메라"
        config.wordings.next = "다음"
        config.wordings.cancel = "취소"
        config.colors.tintColor = .mainPink

        let picker = YPImagePicker(configuration: config)

        picker.didFinishPicking { [unowned picker] items, cancelled in
            if !cancelled {
                let images: [UIImage] = items.compactMap { item in
                    if case .photo(let photo) = item {
                        return photo.image
                    } else {
                        return nil
                    }
                }
                self.viewModel.images = images
                self.listCollectionView.reloadData()
            }
            picker.dismiss(animated: true, completion: nil)
        }
        present(picker, animated: true, completion: nil)
    }

    private func showAlert(message: String) {
        let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        let cancel = UIAlertAction(title: "닫기", style: .cancel, handler: nil)
        alert.addAction(cancel)

        present(alert, animated: true, completion: nil)
    }

    private func tappedCompleteButton() {
        Task {
            await viewModel.createReview()
        }
        dismiss(animated: true, completion: nil)
    }
}

extension CreateReviewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        guard let text = searchController.searchBar.text?.lowercased() else { return }
        searchStores(keyword: text)
    }

    private func searchStores(keyword: String) {
        Task {
            stores = await viewModel.searchStores(keyword: keyword)
            resultsStoreTableViewController.storeInfoTableView.reloadData()
        }
    }
}

extension CreateReviewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_: UITableView, numberOfRowsInSection _: Int) -> Int {
        return stores.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView
            .dequeueReusableCell(withIdentifier: StoreSearchTableViewCell.className, for: indexPath) as? StoreSearchTableViewCell
        else { return UITableViewCell() }

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
        setStore(store: stores[indexPath.item])
    }

    private func setStore(store: Place) {
        let action = UIAction { [weak self] _ in
            let showWebViewController = ShowWebViewController()
            showWebViewController.title = "맛집 정보"
            showWebViewController.url = store.placeURL

            let navigationController = UINavigationController(rootViewController: showWebViewController)
            navigationController.modalPresentationStyle = .fullScreen

            DispatchQueue.main.async {
                self?.present(navigationController, animated: true)
            }
        }

        selectedStoreView.mapButton.addAction(action, for: .touchUpInside)
        selectedStoreView.storeNameLabel.text = store.placeName
        selectedStoreView.storeAdressLabel.text = store.addressName
        selectedStoreView.snp.updateConstraints {
            $0.height.equalTo(60)
        }
        selectedStoreView.isHidden = false

        Task {
            await viewModel.setStore(store: store)
        }
    }
}

extension CreateReviewController: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.text == textViewPlaceHolder {
            textView.text = nil
            textView.textColor = .mainText
        }
    }

    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            textView.text = textViewPlaceHolder
            textView.textColor = .grey001
        }
    }

    func textViewDidChange(_ textView: UITextView) {
        viewModel.request.reviewContent = textView.text
    }
}

extension CreateReviewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_: UICollectionView, numberOfItemsInSection _: Int) -> Int {
        return viewModel.images.count + 1
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.item == 0 {
            guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: PhotoPlusCollectionViewCell.className,
                for: indexPath
            ) as? PhotoPlusCollectionViewCell else {
                return UICollectionViewCell()
            }

            return cell
        } else {
            guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: PhotoCollectionViewCell.className,
                for: indexPath
            ) as? PhotoCollectionViewCell else {
                return UICollectionViewCell()
            }

            cell.foodImageView.image = viewModel.images[indexPath.item - 1]

            return cell
        }
    }

    func collectionView(_: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.item == 0 {
            photoAddButtonDidTap()
        }
    }
}
