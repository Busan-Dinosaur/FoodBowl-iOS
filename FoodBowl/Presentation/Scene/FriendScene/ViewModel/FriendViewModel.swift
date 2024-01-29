//
//  FriendViewModel.swift
//  FoodBowl
//
//  Created by Coby on 1/18/24.
//

import Combine
import Foundation

final class FriendViewModel: BaseViewModelType {
    
    // MARK: - property
    
    private let usecase: FriendUsecase
    private var cancellable = Set<AnyCancellable>()
    
    private var isBookmark: Bool = false
    
    private var location: CustomLocationRequestDTO?
    private let pageSize: Int = 20
    private var currentpageSize: Int = 20
    private var lastReviewId: Int?
    
    private let storesSubject: PassthroughSubject<Result<[Store], Error>, Never> = PassthroughSubject()
    private let reviewsSubject: PassthroughSubject<Result<[Review], Error>, Never> = PassthroughSubject()
    private let moreReviewsSubject: PassthroughSubject<Result<[Review], Error>, Never> = PassthroughSubject()
    private let refreshControlSubject: PassthroughSubject<Void, Error> = PassthroughSubject()
    private let isBookmarkedSubject: PassthroughSubject<Result<Int, Error>, Never> = PassthroughSubject()
    
    struct Input {
        let customLocation: AnyPublisher<CustomLocationRequestDTO, Never>
        let bookmarkToggleButtonDidTap: AnyPublisher<Bool, Never>
        let bookmarkButtonDidTap: AnyPublisher<(Int, Bool), Never>
        let scrolledToBottom: AnyPublisher<Void, Never>
        let refreshControl: AnyPublisher<Void, Never>
    }
    
    struct Output {
        let stores: AnyPublisher<Result<[Store], Error>, Never>
        let reviews: AnyPublisher<Result<[Review], Error>, Never>
        let moreReviews: AnyPublisher<Result<[Review], Error>, Never>
        let isBookmarked: AnyPublisher<Result<Int, Error>, Never>
    }
    
    // MARK: - init

    init(usecase: FriendUsecase) {
        self.usecase = usecase
    }
    
    // MARK: - Public - func
    
    func transform(from input: Input) -> Output {
        input.customLocation
            .debounce(for: .milliseconds(100), scheduler: RunLoop.main)
            .sink(receiveValue: { [weak self] location in
                guard let self = self else { return }
                self.location = location
                self.currentpageSize = self.pageSize
                self.lastReviewId = nil
                self.isBookmark ? self.getReviewsByBookmark() : self.getReviewsByFollowing()
                self.isBookmark ? self.getStoresByBookmark() : self.getStoresByFollowing()
            })
            .store(in: &self.cancellable)
        
        input.bookmarkToggleButtonDidTap
            .removeDuplicates()
            .sink(receiveValue: { [weak self] isBookmark in
                guard let self = self else { return }
                self.currentpageSize = self.pageSize
                self.lastReviewId = nil
                self.isBookmark = !isBookmark
                self.isBookmark ? self.getReviewsByBookmark() : self.getReviewsByFollowing()
                self.isBookmark ? self.getStoresByBookmark() : self.getStoresByFollowing()
            })
            .store(in: &self.cancellable)
        
        input.bookmarkButtonDidTap
            .sink(receiveValue: { [weak self] storeId, isBookmarked in
                guard let self = self else { return }
                isBookmarked ? self.removeBookmark(storeId: storeId) : self.createBookmark(storeId: storeId)
            })
            .store(in: &self.cancellable)
        
        input.scrolledToBottom
            .sink(receiveValue: { [weak self] _ in
                guard let self = self else { return }
                self.isBookmark ? self.getReviewsByBookmark(lastReviewId: self.lastReviewId) : self.getReviewsByFollowing(lastReviewId: self.lastReviewId)
            })
            .store(in: &self.cancellable)
        
        input.refreshControl
            .sink(receiveValue: { [weak self] _ in
                guard let self = self else { return }
                self.currentpageSize = self.pageSize
                self.lastReviewId = nil
                self.isBookmark ? self.getReviewsByBookmark() : self.getReviewsByFollowing()
            })
            .store(in: &self.cancellable)
        
        return Output(
            stores: self.storesSubject.eraseToAnyPublisher(),
            reviews: self.reviewsSubject.eraseToAnyPublisher(),
            moreReviews: self.moreReviewsSubject.eraseToAnyPublisher(),
            isBookmarked: self.isBookmarkedSubject.eraseToAnyPublisher()
        )
    }
    
    // MARK: - network
    
    private func getReviewsByFollowing(lastReviewId: Int? = nil) {
        Task {
            do {
                guard let location = self.location else { return }
                if self.currentpageSize < self.pageSize { return }
                
                let reviews = try await self.usecase.getReviewsByFollowing(request: GetReviewsRequestDTO(
                    location: location,
                    lastReviewId: lastReviewId,
                    pageSize: self.pageSize
                ))
                
                self.lastReviewId = reviews.page.lastId
                self.currentpageSize = reviews.page.size
                
                lastReviewId == nil ? self.reviewsSubject.send(.success(reviews.reviews)) : self.moreReviewsSubject.send(.success(reviews.reviews))
            } catch(let error) {
                self.reviewsSubject.send(.failure(error))
            }
        }
    }
    
    private func getReviewsByBookmark(lastReviewId: Int? = nil) {
        Task {
            do {
                guard let location = self.location else { return }
                if self.currentpageSize < self.pageSize { return }
                
                let reviews = try await self.usecase.getReviewsByFollowing(request: GetReviewsRequestDTO(
                    location: location,
                    lastReviewId: lastReviewId,
                    pageSize: self.pageSize
                ))
                
                self.lastReviewId = reviews.page.lastId
                self.currentpageSize = reviews.page.size
                
                lastReviewId == nil ? self.reviewsSubject.send(.success(reviews.reviews)) : self.moreReviewsSubject.send(.success(reviews.reviews))
            } catch(let error) {
                self.reviewsSubject.send(.failure(error))
            }
        }
    }
    
    private func getStoresByFollowing() {
        Task {
            do {
                guard let location = self.location else { return }
                let stores = try await self.usecase.getStoresByFollowing(request: location)
                self.storesSubject.send(.success(stores))
            } catch(let error) {
                self.storesSubject.send(.failure(error))
            }
        }
    }
    
    private func getStoresByBookmark() {
        Task {
            do {
                guard let location = self.location else { return }
                let stores = try await self.usecase.getStoresByBookmark(request: location)
                self.storesSubject.send(.success(stores))
            } catch(let error) {
                self.storesSubject.send(.failure(error))
            }
        }
    }
    
    func createBookmark(storeId: Int) {
        Task {
            do {
                try await self.usecase.createBookmark(storeId: storeId)
                self.isBookmarkedSubject.send(.success(storeId))
            } catch(let error) {
                self.isBookmarkedSubject.send(.failure(error))
            }
        }
    }
    
    func removeBookmark(storeId: Int) {
        Task {
            do {
                try await self.usecase.removeBookmark(storeId: storeId)
                self.isBookmarkedSubject.send(.success(storeId))
            } catch(let error) {
                self.isBookmarkedSubject.send(.failure(error))
            }
        }
    }
}
