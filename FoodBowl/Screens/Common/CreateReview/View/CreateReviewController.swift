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

    private var viewModel = CreateReviewViewModel()

    private let textViewPlaceHolder = "100자 이내"

    private let newFeedGuideLabel = PaddingLabel().then {
        $0.font = .font(.regular, ofSize: 22)
        $0.text = "후기 작성"
        $0.textColor = .mainTextColor
        $0.padding = UIEdgeInsets(top: 0, left: 4, bottom: 0, right: 0)
        $0.frame = CGRect(x: 0, y: 0, width: 150, height: 0)
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

    private lazy var selectedStoreView = SelectedStoreView().then {
        $0.isHidden = true
    }

    private lazy var searchBarButton = SearchBarButton().then {
        $0.placeholderLabel.text = "가게 검색"
        let action = UIAction { [weak self] _ in
            guard let viewModel = self?.viewModel else { return }
            let searchStoreViewController = SearchStoreViewController(viewModel: viewModel)
            DispatchQueue.main.async {
                self?.navigationController?.pushViewController(searchStoreViewController, animated: true)
            }
        }
        $0.addAction(action, for: .touchUpInside)
    }

    private let guideCommentLabel = UILabel().then {
        $0.text = "한줄평"
        $0.font = .font(.regular, ofSize: 17)
        $0.textColor = .mainTextColor
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

    private let guidePhotoLabel = UILabel().then {
        $0.text = "사진"
        $0.font = .font(.regular, ofSize: 17)
        $0.textColor = .mainTextColor
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

    private lazy var completeButton = MainButton().then {
        $0.label.text = "완료"
        let action = UIAction { [weak self] _ in
            self?.tappedCompleteButton()
        }
        $0.addAction(action, for: .touchUpInside)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setStore()
    }

    override func setupLayout() {
        view.addSubviews(
            searchBarButton,
            selectedStoreView,
            commentTextView,
            completeButton,
            guidePhotoLabel,
            listCollectionView,
            guideCommentLabel
        )

        searchBarButton.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide)
            $0.leading.trailing.equalToSuperview().inset(BaseSize.horizantalPadding)
            $0.height.equalTo(40)
        }

        selectedStoreView.snp.makeConstraints {
            $0.top.equalTo(searchBarButton.snp.bottom).offset(10)
            $0.leading.trailing.equalToSuperview().inset(BaseSize.horizantalPadding)
            $0.height.equalTo(60)
        }

        guideCommentLabel.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(80)
            $0.leading.equalToSuperview().inset(BaseSize.horizantalPadding)
        }

        commentTextView.snp.makeConstraints {
            $0.top.equalTo(guideCommentLabel.snp.bottom).offset(10)
            $0.leading.trailing.equalToSuperview().inset(BaseSize.horizantalPadding)
            $0.height.equalTo(100)
        }

        guidePhotoLabel.snp.makeConstraints {
            $0.top.equalTo(commentTextView.snp.bottom).offset(30)
            $0.leading.equalToSuperview().inset(BaseSize.horizantalPadding)
        }

        listCollectionView.snp.makeConstraints {
            $0.top.equalTo(guidePhotoLabel.snp.bottom).offset(10)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(100)
        }

        completeButton.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(BaseSize.horizantalPadding)
            $0.bottom.equalToSuperview().inset(BaseSize.bottomPadding)
            $0.height.equalTo(60)
        }
    }

    override func setupNavigationBar() {
        super.setupNavigationBar()
        let newFeedGuideLabel = makeBarButtonItem(with: newFeedGuideLabel)
        let closeButton = makeBarButtonItem(with: closeButton)
        navigationItem.leftBarButtonItem = newFeedGuideLabel
        navigationItem.rightBarButtonItem = closeButton
    }

    private func setStore() {
        if let store = viewModel.store {
            let action = UIAction { [weak self] _ in
                let showWebViewController = ShowWebViewController()
                showWebViewController.url = store.placeURL

                let navigationController = UINavigationController(rootViewController: showWebViewController)

                DispatchQueue.main.async {
                    self?.present(navigationController, animated: true)
                }
            }

            selectedStoreView.mapButton.addAction(action, for: .touchUpInside)
            selectedStoreView.storeNameLabel.text = store.placeName
            selectedStoreView.storeAdressLabel.text = store.addressName
            selectedStoreView.isHidden = false

            searchBarButton.placeholderLabel.text = "가게 재검색"

            guideCommentLabel.snp.updateConstraints {
                $0.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(150)
            }
        }
    }

    private func showAlert(message: String) {
        let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        let cancel = UIAlertAction(title: "닫기", style: .cancel, handler: nil)
        alert.addAction(cancel)

        present(alert, animated: true, completion: nil)
    }

    private func tappedCompleteButton() {
        if viewModel.store == nil {
            showAlert(message: "가게를 선택하지 않았습니다.")
            return
        }

        if viewModel.reviewRequest.reviewContent == "" {
            showAlert(message: "한줄평을 작성하지 않았습니다.")
            return
        }

        Task {
            animationView!.isHidden = false
            await viewModel.createReview()
            animationView!.isHidden = true
            dismiss(animated: true, completion: nil)
        }
    }
}

extension CreateReviewController: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.text == textViewPlaceHolder {
            textView.text = nil
            textView.textColor = .mainTextColor
        }
    }

    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            textView.text = textViewPlaceHolder
            textView.textColor = .grey001
        }
    }

    func textViewDidChange(_ textView: UITextView) {
        viewModel.reviewRequest.reviewContent = textView.text
    }
}

extension CreateReviewController {
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
                self.viewModel.reviewImages = images
                self.listCollectionView.reloadData()
            }
            picker.dismiss(animated: true, completion: nil)
        }
        present(picker, animated: true, completion: nil)
    }
}

extension CreateReviewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_: UICollectionView, numberOfItemsInSection _: Int) -> Int {
        return viewModel.reviewImages.count + 1
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

            cell.foodImageView.image = viewModel.reviewImages[indexPath.item - 1]

            return cell
        }
    }

    func collectionView(_: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.item == 0 {
            photoAddButtonDidTap()
        }
    }
}
