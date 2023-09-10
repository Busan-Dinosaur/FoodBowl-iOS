//
//  SetReviewViewController.swift
//  FoodBowl
//
//  Created by COBY_PRO on 2022/12/23.
//

import UIKit

import SnapKit
import Then
import YPImagePicker

final class SetReviewViewController: BaseViewController {
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

    private var selectedImages = [UIImage]()
    private let textViewPlaceHolder = "100자 이내"

    private var viewModel: NewFeedViewModel

    init(viewModel: NewFeedViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - property

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

    // MARK: - life cycle

    override func setupLayout() {
        view.addSubviews(guidePhotoLabel, listCollectionView, guideCommentLabel, commentTextView)

        guidePhotoLabel.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top).inset(20)
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
                self.selectedImages = images
                self.listCollectionView.reloadData()
            }
            picker.dismiss(animated: true, completion: nil)
        }
        present(picker, animated: true, completion: nil)
    }
}

extension SetReviewViewController: UITextViewDelegate {
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
        viewModel.newFeed.reviewContent = textView.text
    }
}

extension SetReviewViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_: UICollectionView, numberOfItemsInSection _: Int) -> Int {
        return selectedImages.count + 1
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

            cell.foodImageView.image = selectedImages[indexPath.item - 1]

            return cell
        }
    }

    func collectionView(_: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.item == 0 {
            photoAddButtonDidTap()
        }
    }
}
