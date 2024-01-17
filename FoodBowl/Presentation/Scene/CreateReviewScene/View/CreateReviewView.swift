//
//  CreateReviewView.swift
//  FoodBowl
//
//  Created by Coby on 1/17/24.
//

import Combine
import UIKit

import SnapKit
import Then

final class CreateReviewView: UIView, BaseViewType {
    
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
    
    // MARK: - ui component
    
    private let scrollView = UIScrollView().then {
        $0.isScrollEnabled = true
        $0.showsVerticalScrollIndicator = false
    }
    private let contentView = UIView()
    private let newFeedGuideLabel = PaddingLabel().then {
        $0.font = .font(.regular, ofSize: 22)
        $0.text = "후기 작성"
        $0.textColor = .mainTextColor
        $0.padding = UIEdgeInsets(top: 0, left: 4, bottom: 0, right: 0)
        $0.frame = CGRect(x: 0, y: 0, width: 150, height: 0)
    }
    private let closeButton = UIButton().then {
        $0.setTitle("닫기", for: .normal)
        $0.setTitleColor(.mainPink, for: .normal)
        $0.titleLabel?.font = UIFont.preferredFont(forTextStyle: .headline, weight: .regular)
    }
    private lazy var selectedStoreView = SelectedStoreView().then {
        $0.isHidden = true
    }
    private let searchBarButton = SearchBarButton()
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
        $0.showsVerticalScrollIndicator = false
        $0.register(PhotoPlusCollectionViewCell.self, forCellWithReuseIdentifier: PhotoPlusCollectionViewCell.className)
        $0.register(PhotoCollectionViewCell.self, forCellWithReuseIdentifier: PhotoCollectionViewCell.className)
        $0.backgroundColor = .clear
        $0.showsHorizontalScrollIndicator = false
    }
    private let completeButton = CompleteButton()
    
    // MARK: - property
    
    private let textViewPlaceHolder = "100자 이내"
    var reviewImages = [UIImage]()
    
    var closeButtonDidTapPublisher: AnyPublisher<Void, Never> {
        return self.closeButton.buttonTapPublisher
    }
    var searchBarButtonDidTapPublisher: AnyPublisher<Void, Never> {
        return self.searchBarButton.buttonTapPublisher
    }
    let completeButtonDidTapPublisher = PassthroughSubject<(String, [UIImage]), Never>()
    let maxLengthAlertPublisher = PassthroughSubject<Void, Never>()
    
    // MARK: - init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.baseInit()
        self.setupAction()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - func
    
    func configureNavigationBarItem(_ navigationController: UINavigationController) {
        let navigationItem = navigationController.topViewController?.navigationItem
        let newFeedGuideLabel = navigationController.makeBarButtonItem(with: newFeedGuideLabel)
        let closeButton = navigationController.makeBarButtonItem(with: closeButton)
        navigationItem?.leftBarButtonItem = newFeedGuideLabel
        navigationItem?.rightBarButtonItem = closeButton
    }
    
    func configureDelegation(_ delegate: UICollectionViewDataSource) {
        self.listCollectionView.dataSource = delegate
    }
    
    func updateCollectionView() {
        self.listCollectionView.reloadData()
    }
    
    // MARK: - base func
    
    func setupLayout() {
        self.addSubviews(self.scrollView, self.completeButton)
        
        self.scrollView.snp.makeConstraints {
            $0.top.equalTo(self.safeAreaLayoutGuide.snp.top)
            $0.bottom.equalTo(self.completeButton.snp.top).offset(-20)
            $0.leading.trailing.equalToSuperview()
        }
        
        self.scrollView.addSubview(contentView)
        
        self.contentView.snp.makeConstraints {
            $0.width.equalToSuperview()
            $0.top.bottom.equalToSuperview()
        }
        
        self.contentView.addSubviews(
            self.searchBarButton,
            self.selectedStoreView,
            self.guideCommentLabel,
            self.commentTextView,
            self.guidePhotoLabel,
            self.listCollectionView
        )

        self.searchBarButton.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.leading.trailing.equalToSuperview().inset(SizeLiteral.horizantalPadding)
            $0.height.equalTo(40)
        }

        self.selectedStoreView.snp.makeConstraints {
            $0.top.equalTo(searchBarButton.snp.bottom).offset(10)
            $0.leading.trailing.equalToSuperview().inset(SizeLiteral.horizantalPadding)
            $0.height.equalTo(60)
        }

        self.guideCommentLabel.snp.makeConstraints {
            $0.top.equalTo(self.safeAreaLayoutGuide.snp.top).offset(80)
            $0.leading.equalToSuperview().inset(SizeLiteral.horizantalPadding)
        }

        self.commentTextView.snp.makeConstraints {
            $0.top.equalTo(self.guideCommentLabel.snp.bottom).offset(10)
            $0.leading.trailing.equalToSuperview().inset(SizeLiteral.horizantalPadding)
            $0.height.equalTo(100)
        }

        self.guidePhotoLabel.snp.makeConstraints {
            $0.top.equalTo(self.commentTextView.snp.bottom).offset(30)
            $0.leading.equalToSuperview().inset(SizeLiteral.horizantalPadding)
        }

        self.listCollectionView.snp.makeConstraints {
            $0.top.equalTo(self.guidePhotoLabel.snp.bottom).offset(10)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(100)
            $0.bottom.equalToSuperview()
        }

        self.completeButton.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(SizeLiteral.horizantalPadding)
            $0.bottom.equalToSuperview().inset(SizeLiteral.bottomPadding)
            $0.height.equalTo(60)
        }
    }
    
    func configureUI() {
        self.backgroundColor = .mainBackgroundColor
    }
    
    // MARK: - Private - func

    private func setupAction() {
        let completeAction = UIAction { [weak self] _ in
            guard let self = self else { return }
            guard let comment = self.commentTextView.text else { return }
            self.completeButtonDidTapPublisher.send((comment, self.reviewImages))
        }
        self.completeButton.addAction(completeAction, for: .touchUpInside)
    }
}

extension CreateReviewView: UITextViewDelegate {
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        let currentText = textView.text as NSString
        let newText = currentText.replacingCharacters(in: range, with: text)
        
        if newText.count > 100 {
            self.maxLengthAlertPublisher.send()
            return false
        }
        return true
    }
    
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
}
