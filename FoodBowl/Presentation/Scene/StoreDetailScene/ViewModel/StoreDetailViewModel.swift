//
//  StoreDetailViewModel.swift
//  FoodBowl
//
//  Created by COBY_PRO on 10/16/23.
//

import Combine
import Foundation

final class StoreDetailViewModel: BaseViewModelType {
    
    // MARK: - property
    
    private let storeId: Int
    var isFriend: Bool
    
    private let usecase: StoreDetailUsecase
    private var cancellable = Set<AnyCancellable>()
    
    private let pageSize: Int = 20
    private var currentpageSize: Int = 20
    private var lastReviewId: Int?
    
    private let storeSubject: PassthroughSubject<Result<Store, Error>, Never> = PassthroughSubject()
    private let reviewsSubject: PassthroughSubject<Result<[ReviewItem], Error>, Never> = PassthroughSubject()
    private let moreReviewsSubject: PassthroughSubject<Result<[ReviewItem], Error>, Never> = PassthroughSubject()
    private let refreshControlSubject: PassthroughSubject<Void, Error> = PassthroughSubject()
    private let isRemovedSubject: PassthroughSubject<Result<Int, Error>, Never> = PassthroughSubject()
    
    struct Input {
        let reviewToggleButtonDidTap: AnyPublisher<Bool, Never>
        let bookmarkButtonDidTap: AnyPublisher<Bool, Never>
        let removeReview: AnyPublisher<Int, Never>
        let scrolledToBottom: AnyPublisher<Void, Never>
        let refreshControl: AnyPublisher<Void, Never>
    }
    
    struct Output {
        let store: AnyPublisher<Result<Store, Error>, Never>
        let reviews: AnyPublisher<Result<[ReviewItem], Error>, Never>
        let moreReviews: AnyPublisher<Result<[ReviewItem], Error>, Never>
        let isRemoved: AnyPublisher<Result<Int, Error>, Never>
    }
    
    // MARK: - init

    init(storeId: Int, isFriend: Bool, usecase: StoreDetailUsecase) {
        self.storeId = storeId
        self.isFriend = isFriend
        self.usecase = usecase
    }
    
    // MARK: - Public - func
    
    func transform(from input: Input) -> Output {
        self.getReviews()
        
        input.reviewToggleButtonDidTap
            .sink(receiveValue: { [weak self] isFriend in
                guard let self = self else { return }
                self.currentpageSize = self.pageSize
                self.lastReviewId = nil
                self.isFriend = isFriend
                self.getReviews()
            })
            .store(in: &self.cancellable)
        
        input.bookmarkButtonDidTap
            .sink(receiveValue: { [weak self] isBookmark in
                guard let self = self else { return }
                isBookmark ? self.removeBookmark() : self.createBookmark()
            })
            .store(in: &self.cancellable)
        
        input.removeReview
            .sink(receiveValue: { [weak self] reviewId in
                guard let self = self else { return }
                self.removeReview(id: reviewId)
            })
            .store(in: &self.cancellable)
        
        input.scrolledToBottom
            .sink(receiveValue: { [weak self] _ in
                guard let self = self else { return }
                self.getReviews(lastReviewId: self.lastReviewId)
            })
            .store(in: &self.cancellable)
        
        input.refreshControl
            .sink(receiveValue: { [weak self] _ in
                guard let self = self else { return }
                self.currentpageSize = self.pageSize
                self.lastReviewId = nil
                self.getReviews()
            })
            .store(in: &self.cancellable)
        
        return Output(
            store: storeSubject.eraseToAnyPublisher(),
            reviews: reviewsSubject.eraseToAnyPublisher(),
            moreReviews: moreReviewsSubject.eraseToAnyPublisher(),
            isRemoved: isRemovedSubject.eraseToAnyPublisher()
        )
    }
    
    // MARK: - network
    
    private func getReviews(lastReviewId: Int? = nil) {
        Task {
            do {
                if currentpageSize < pageSize { return }
                let filter = self.isFriend ? "FRIEND" : "ALL"
                let deviceX = LocationManager.shared.manager.location?.coordinate.longitude ?? 0.0
                let deviceY = LocationManager.shared.manager.location?.coordinate.latitude ?? 0.0
                
                let data = try await self.usecase.getReviewsByStore(request: GetReviewsByStoreRequestDTO(
                    lastReviewId: lastReviewId,
                    pageSize: self.pageSize,
                    storeId: self.storeId,
                    filter: filter,
                    deviceX: deviceX,
                    deviceY: deviceY
                ))
                
                let store = data.reviewStoreResponse.toStore()
                self.storeSubject.send(.success(store))
                
                let review = data.toReview()
                
                self.lastReviewId = review.page.lastId
                self.currentpageSize = review.page.size
                
                lastReviewId == nil ? self.reviewsSubject.send(.success(review.reviews)) : self.moreReviewsSubject.send(.success(review.reviews))
            } catch(let error) {
                self.reviewsSubject.send(.failure(error))
            }
        }
    }
    
    func removeReview(id: Int) {
        Task {
            do {
                try await self.usecase.removeReview(id: id)
                self.isRemovedSubject.send(.success(id))
            } catch {
                self.isRemovedSubject.send(.failure(NetworkError()))
            }
        }
    }
    
    func createBookmark() {
        Task {
            do {
                try await self.usecase.createBookmark(storeId: self.storeId)
            } catch {
                print("Failed to Create Bookmark")
            }
        }
    }
    
    func removeBookmark() {
        Task {
            do {
                try await self.usecase.removeBookmark(storeId: self.storeId)
            } catch {
                print("Failed to Remove Bookmark")
            }
        }
    }
}
