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
    
    var storeId: Int
    var isFriend: Bool
    
    private let usecase: StoreDetailUsecase
    private var cancelBag = Set<AnyCancellable>()
    
    private let pageSize: Int = 20
    private var currentpageSize: Int = 20
    private var lastReviewId: Int?
    private var reviews = [ReviewItem]()
    
    private let reviewsSubject = PassthroughSubject<[ReviewItem], Error>()
    private let refreshControlSubject = PassthroughSubject<Void, Error>()
    private let isRemovedSubject: PassthroughSubject<Result<Bool, Error>, Never> = PassthroughSubject()
    
    struct Input {
        let reviewToggleButtonDidTap: AnyPublisher<Bool, Never>
        let scrolledToBottom: AnyPublisher<Void, Never>
        let refreshControl: AnyPublisher<Void, Never>
    }
    
    struct Output {
        let reviews: PassthroughSubject<[ReviewItem], Error>
        let refreshControl: PassthroughSubject<Void, Error>
    }
    
    // MARK: - init

    init(storeId: Int, isFriend: Bool, usecase: StoreDetailUsecase) {
        self.storeId = storeId
        self.isFriend = isFriend
        self.usecase = usecase
    }
    
    // MARK: - Public - func
    
    func transform(from input: Input) -> Output {
        self.getReviewsPublisher(isFriend: self.isFriend)
        
        input.reviewToggleButtonDidTap
            .sink(receiveValue: { [weak self] isFriend in
                guard let self = self else { return }
                self.currentpageSize = self.pageSize
                self.lastReviewId = nil
                self.isFriend = isFriend
                self.getReviewsPublisher(isFriend: isFriend)
            })
            .store(in: &self.cancelBag)
        
        input.scrolledToBottom
            .sink(receiveValue: { [weak self] _ in
                guard let self = self else { return }
                self.getReviewsPublisher(isFriend: self.isFriend, lastReviewId: self.lastReviewId)
            })
            .store(in: &self.cancelBag)
        
        input.refreshControl
            .sink(receiveValue: { [weak self] _ in
                guard let self = self else { return }
                self.currentpageSize = self.pageSize
                self.lastReviewId = nil
                self.getReviewsPublisher(isFriend: isFriend)
            })
            .store(in: &self.cancelBag)
        
        return Output(
            reviews: reviewsSubject,
            refreshControl: refreshControlSubject
        )
    }
    
    // MARK: - network
    
    private func getReviewsPublisher(isFriend: Bool, lastReviewId: Int? = nil) {
        Task {
            do {
                if currentpageSize < pageSize { return }
                let filter = isFriend ? "FRIEND" : "ALL"
                
                let review = try await self.usecase.getReviewsByStore(request: GetReviewsByStoreRequestDTO(
                    lastReviewId: lastReviewId,
                    pageSize: self.pageSize,
                    storeId: self.storeId,
                    filter: filter
                )).toReview()
                
                self.lastReviewId = review.page.lastId
                self.currentpageSize = review.page.size
                
                if lastReviewId == nil {
                    self.reviews = review.reviews
                } else {
                    self.reviews += review.reviews
                }
                self.reviewsSubject.send(self.reviews)
            } catch {
                self.reviewsSubject.send(completion: .failure(error))
            }
        }
    }
    
    func removeReview(id: Int) {
        Task {
            do {
                try await self.usecase.removeReview(id: id)
            } catch {
                self.isRemovedSubject.send(.failure(NetworkError()))
            }
        }
    }
}
