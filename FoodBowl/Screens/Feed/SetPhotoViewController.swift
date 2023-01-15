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
    private enum Size {
        static let cellWidth: CGFloat = (UIScreen.main.bounds.size.width - 56) / 3
        static let cellHeight: CGFloat = cellWidth
        static let collectionInset = UIEdgeInsets(top: 0,
                                                  left: 20,
                                                  bottom: 20,
                                                  right: 20)
    }

    // MARK: - property

    private let guideLabel = UILabel().then {
        $0.text = "음식 사진들을 등록해주세요."
        $0.font = UIFont.preferredFont(forTextStyle: .title3, weight: .medium)
    }

    private let galleryButton = GalleryButton()

    private let collectionViewFlowLayout = UICollectionViewFlowLayout().then {
        $0.scrollDirection = .vertical
        $0.sectionInset = Size.collectionInset
        $0.itemSize = CGSize(width: Size.cellWidth, height: Size.cellHeight)
        $0.minimumLineSpacing = 8
        $0.minimumInteritemSpacing = 8
    }

    private lazy var listCollectionView = UICollectionView(frame: .zero, collectionViewLayout: collectionViewFlowLayout).then {
        $0.dataSource = self
        $0.delegate = self
        $0.showsVerticalScrollIndicator = false
        $0.register(FeedThumnailCollectionViewCell.self, forCellWithReuseIdentifier: FeedThumnailCollectionViewCell.className)
    }

    // MARK: - life cycle

    override func render() {
        view.addSubviews(guideLabel, galleryButton, listCollectionView)

        guideLabel.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top).inset(20)
            $0.leading.equalToSuperview().inset(20)
        }

        galleryButton.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top).inset(20)
            $0.trailing.equalToSuperview().inset(20)
        }

        listCollectionView.snp.makeConstraints {
            $0.top.equalTo(guideLabel.safeAreaLayoutGuide.snp.bottom).offset(20)
            $0.leading.trailing.bottom.equalToSuperview()
        }
    }

    func photoAddButtonDidTap(_: UIButton) {
        var config = YPImagePickerConfiguration()
        config.library.maxNumberOfItems = 10 // 최대 선택 가능한 사진 개수 제한
        config.library.mediaType = .photo // 미디어타입(사진, 사진/동영상, 동영상)

        let picker = YPImagePicker(configuration: config)

        picker.didFinishPicking { [unowned picker] items, _ in
            if let photo = items.singlePhoto {
                print(photo.fromCamera) // Image source (camera or library)
                print(photo.image) // Final image selected by the user
                print(photo.originalImage) // original image selected by the user, unfiltered
                print(photo.modifiedImage) // Transformed image, can be nil
                print(photo.exifMeta) // Print exif meta data of original image.
            }
            picker.dismiss(animated: true, completion: nil)
        }
        present(picker, animated: true, completion: nil)
    }
}

extension SetPhotoViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_: UICollectionView, numberOfItemsInSection _: Int) -> Int {
        return 10
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FeedThumnailCollectionViewCell.className, for: indexPath) as? FeedThumnailCollectionViewCell else {
            return UICollectionViewCell()
        }

        return cell
    }

    func collectionView(_: UICollectionView, didSelectItemAt _: IndexPath) {}
}
