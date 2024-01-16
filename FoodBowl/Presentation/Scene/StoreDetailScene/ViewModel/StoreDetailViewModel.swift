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
    
    let store: Store
    var isFriend: Bool
    
    private let usecase: StoreDetailUsecase
    private var cancelBag = Set<AnyCancellable>()
    
    private let pageSize: Int = 20
    private var currentpageSize: Int = 20
    private var lastReviewId: Int?
    
    private let reviewsSubject = PassthroughSubject<[ReviewItem], Error>()
    private let moreReviewsSubject = PassthroughSubject<[ReviewItem], Error>()
    private let refreshControlSubject = PassthroughSubject<Void, Error>()
    private let isRemovedSubject: PassthroughSubject<Result<Int, Error>, Never> = PassthroughSubject()
    
    struct Input {
        let reviewToggleButtonDidTap: AnyPublisher<Bool, Never>
        let removeReview: AnyPublisher<Int, Never>
        let scrolledToBottom: AnyPublisher<Void, Never>
        let refreshControl: AnyPublisher<Void, Never>
    }
    
    struct Output {
        let reviews: PassthroughSubject<[ReviewItem], Error>
        let moreReviews: PassthroughSubject<[ReviewItem], Error>
        let refreshControl: PassthroughSubject<Void, Error>
        let isRemoved: AnyPublisher<Result<Int, Error>, Never>
    }
    
    // MARK: - init

    init(store: Store, isFriend: Bool, usecase: StoreDetailUsecase) {
        self.store = store
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
                self.getReviews()
            })
            .store(in: &self.cancelBag)
        
        input.removeReview
            .sink(receiveValue: { [weak self] reviewId in
                guard let self = self else { return }
                self.removeReview(id: reviewId)
            })
            .store(in: &self.cancelBag)
        
        input.scrolledToBottom
            .sink(receiveValue: { [weak self] _ in
                guard let self = self else { return }
                self.getReviews(lastReviewId: self.lastReviewId)
            })
            .store(in: &self.cancelBag)
        
        input.refreshControl
            .sink(receiveValue: { [weak self] _ in
                guard let self = self else { return }
                self.currentpageSize = self.pageSize
                self.lastReviewId = nil
                self.getReviews()
            })
            .store(in: &self.cancelBag)
        
        return Output(
            reviews: reviewsSubject,
            moreReviews: moreReviewsSubject,
            refreshControl: refreshControlSubject,
            isRemoved: isRemovedSubject.eraseToAnyPublisher()
        )
    }
    
    // MARK: - network
    
    private func getReviews(lastReviewId: Int? = nil) {
        Task {
            do {
                if currentpageSize < pageSize { return }
                let filter = self.isFriend ? "FRIEND" : "ALL"
                
                let review = try await self.usecase.getReviewsByStore(request: GetReviewsByStoreRequestDTO(
                    lastReviewId: lastReviewId,
                    pageSize: self.pageSize,
                    storeId: self.store.id,
                    filter: filter
                )).toReview()
                
                self.lastReviewId = review.page.lastId
                self.currentpageSize = review.page.size
                
                lastReviewId == nil ? self.reviewsSubject.send(review.reviews) : self.moreReviewsSubject.send(review.reviews)
            } catch {
                self.reviewsSubject.send(completion: .failure(error))
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
}
