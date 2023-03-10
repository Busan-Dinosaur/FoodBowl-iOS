//
//  SetPhotoViewController.swift
//  FoodBowl
//
//  Created by COBY_PRO on 2022/12/23.
//

import UIKit

import SnapKit
import Then
import YPImagePicker

final class SetPhotoViewController: BaseViewController {
    var delegate: SetPhotoViewControllerDelegate?
    var delegateForComment: SetPhotoViewControllerDelegateForComment?

    private enum Size {
        static let cellWidth: CGFloat = (UIScreen.main.bounds.size.width - 48) / 3
        static let cellHeight: CGFloat = cellWidth
        static let collectionInset = UIEdgeInsets(
            top: 0,
            left: 20,
            bottom: 20,
            right: 20
        )
    }

    private var selectedImages = [UIImage]()

    // MARK: - property

    private let guideLabel = UILabel().then {
        $0.text = "음식 사진을 등록해주세요."
        $0.font = UIFont.preferredFont(forTextStyle: .title3, weight: .medium)
        $0.textColor = .mainText
    }

    private let collectionViewFlowLayout = UICollectionViewFlowLayout().then {
        $0.scrollDirection = .vertical
        $0.sectionInset = Size.collectionInset
        $0.itemSize = CGSize(width: Size.cellWidth, height: Size.cellHeight)
        $0.minimumLineSpacing = 4
        $0.minimumInteritemSpacing = 4
    }

    private lazy var listCollectionView = UICollectionView(frame: .zero, collectionViewLayout: collectionViewFlowLayout).then {
        $0.dataSource = self
        $0.delegate = self
        $0.showsVerticalScrollIndicator = false
        $0.register(PhotoCollectionViewCell.self, forCellWithReuseIdentifier: PhotoCollectionViewCell.className)
        $0.register(FeedThumnailCollectionViewCell.self, forCellWithReuseIdentifier: FeedThumnailCollectionViewCell.className)
        $0.backgroundColor = .clear
    }

    // MARK: - life cycle

    override func setupLayout() {
        view.addSubviews(guideLabel, listCollectionView)

        guideLabel.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top).inset(20)
            $0.leading.equalToSuperview().inset(20)
        }

        listCollectionView.snp.makeConstraints {
            $0.top.equalTo(guideLabel.safeAreaLayoutGuide.snp.bottom).offset(20)
            $0.leading.trailing.bottom.equalToSuperview()
        }
    }

    private func photoAddButtonDidTap() {
        var config = YPImagePickerConfiguration()
        config.onlySquareImagesFromCamera = true
        config.library.maxNumberOfItems = 10 // 최대 선택 가능한 사진 개수 제한
        config.library.minNumberOfItems = 1
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

                self.delegate?.setPhotoes(photoes: images)
                self.delegateForComment?.setPhotoes(photoes: images)
            }
            picker.dismiss(animated: true, completion: nil)
        }
        present(picker, animated: true, completion: nil)
    }
}

extension SetPhotoViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_: UICollectionView, numberOfItemsInSection _: Int) -> Int {
        return selectedImages.count + 1
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.item == 0 {
            guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: PhotoCollectionViewCell.className,
                for: indexPath
            ) as? PhotoCollectionViewCell else {
                return UICollectionViewCell()
            }

            return cell
        } else {
            guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: FeedThumnailCollectionViewCell.className,
                for: indexPath
            ) as? FeedThumnailCollectionViewCell else {
                return UICollectionViewCell()
            }

            cell.thumnailImageView.image = selectedImages[indexPath.item - 1]

            return cell
        }
    }

    func collectionView(_: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.item == 0 {
            photoAddButtonDidTap()
        }
    }
}

protocol SetPhotoViewControllerDelegate: AnyObject {
    func setPhotoes(photoes: [UIImage]?)
}

protocol SetPhotoViewControllerDelegateForComment: AnyObject {
    func setPhotoes(photoes: [UIImage]?)
}
