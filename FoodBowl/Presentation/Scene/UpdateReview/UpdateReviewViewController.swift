//
//  UpdateReviewViewController.swift
//  FoodBowl
//
//  Created by COBY_PRO on 2023/09/12.
//

import UIKit

import SnapKit
import Then
import YPImagePicker

final class UpdateReviewViewController: BaseViewController {
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

    var delegate: CreateReviewControllerDelegate?

    private var viewModel: UpdateReviewViewModel

    private var images = [UIImage]()

    private let textViewPlaceHolder = "100자 이내"

    init(viewModel: UpdateReviewViewModel) {
        self.viewModel = viewModel
        super.init()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - property
    private let editFeedGuideLabel = PaddingLabel().then {
        $0.font = .font(.regular, ofSize: 22)
        $0.text = "후기 수정"
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

    private lazy var completeButton = CompleteButton().then {
        let action = UIAction { [weak self] _ in
            self?.tappedCompleteButton()
        }
        $0.addAction(action, for: .touchUpInside)
    }

    // MARK: - life cycle
    override func setupLayout() {
        view.addSubviews(
            commentTextView,
            completeButton,
            guidePhotoLabel,
            listCollectionView,
            guideCommentLabel
        )

        guideCommentLabel.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(20)
            $0.leading.equalToSuperview().inset(SizeLiteral.horizantalPadding)
        }

        commentTextView.snp.makeConstraints {
            $0.top.equalTo(guideCommentLabel.snp.bottom).offset(10)
            $0.leading.trailing.equalToSuperview().inset(SizeLiteral.horizantalPadding)
            $0.height.equalTo(100)
        }

        guidePhotoLabel.snp.makeConstraints {
            $0.top.equalTo(commentTextView.snp.bottom).offset(30)
            $0.leading.equalToSuperview().inset(SizeLiteral.horizantalPadding)
        }

        listCollectionView.snp.makeConstraints {
            $0.top.equalTo(guidePhotoLabel.snp.bottom).offset(10)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(100)
        }

        completeButton.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(SizeLiteral.horizantalPadding)
            $0.bottom.equalToSuperview().inset(SizeLiteral.bottomPadding)
            $0.height.equalTo(60)
        }
    }

    override func configureUI() {
        super.configureUI()
        commentTextView.text = viewModel.reviewContent
    }

    override func setupNavigationBar() {
        let editFeedGuideLabel = makeBarButtonItem(with: editFeedGuideLabel)
        let closeButton = makeBarButtonItem(with: closeButton)
        navigationItem.leftBarButtonItem = editFeedGuideLabel
        navigationItem.rightBarButtonItem = closeButton
    }

    private func tappedCompleteButton() {
        if viewModel.reviewContent == "" {
            makeAlert(title: "한줄평을 남겨주세요.")
            return
        }

        Task {
            animationView!.isHidden = false
            await viewModel.updateReview()
            animationView!.isHidden = true

            delegate?.updateData()
            dismiss(animated: true, completion: nil)
        }
    }
}

extension UpdateReviewViewController: UITextViewDelegate {
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
        viewModel.reviewContent = textView.text
    }
}

extension UpdateReviewViewController {
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
                self.images = images
                self.listCollectionView.reloadData()
            }
            picker.dismiss(animated: true, completion: nil)
        }
        present(picker, animated: true, completion: nil)
    }
}

extension UpdateReviewViewController: UICollectionViewDataSource, UICollectionViewDelegate {
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

//            cell.foodImageView.image = images[indexPath.item - 1]

            return cell
        }
    }

    func collectionView(_: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.item == 0 {
            photoAddButtonDidTap()
        }
    }
}
