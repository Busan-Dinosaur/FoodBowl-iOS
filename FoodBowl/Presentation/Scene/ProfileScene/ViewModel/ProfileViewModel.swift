//
//  ProfileViewModel.swift
//  FoodBowl
//
//  Created by Coby on 1/21/24.
//

import Combine
import Foundation

final class ProfileViewModel: BaseViewModelType {
    
    // MARK: - property
    
    private let usecase: ProfileUsecase
    private var cancellable = Set<AnyCancellable>()
    
    let memberId: Int
    
    private var location: CustomLocationRequestDTO?
    private let pageSize: Int = 20
    private var currentpageSize: Int = 20
    private var lastReviewId: Int?
    
    private let memberSubject: PassthroughSubject<Result<Member, Error>, Never> = PassthroughSubject()
    private let followMemberSubject: PassthroughSubject<Result<Int, Error>, Never> = PassthroughSubject()
    private let storesSubject: PassthroughSubject<Result<[Store], Error>, Never> = PassthroughSubject()
    private let reviewsSubject: PassthroughSubject<Result<[Review], Error>, Never> = PassthroughSubject()
    private let moreReviewsSubject: PassthroughSubject<Result<[Review], Error>, Never> = PassthroughSubject()
    private let refreshControlSubject: PassthroughSubject<Void, Error> = PassthroughSubject()
    private let isBookmarkSubject: PassthroughSubject<Result<Int, Error>, Never> = PassthroughSubject()
    
    struct Input {
        let viewDidLoad: AnyPublisher<Void, Never>
        let viewWillAppear: AnyPublisher<Void, Never>
        let followMember: AnyPublisher<(Int, Bool), Never>
        let customLocation: AnyPublisher<CustomLocationRequestDTO, Never>
        let bookmarkButtonDidTap: AnyPublisher<(Int, Bool), Never>
        let scrolledToBottom: AnyPublisher<Void, Never>
        let refreshControl: AnyPublisher<Void, Never>
    }
    
    struct Output {
        let member: AnyPublisher<Result<Member, Error>, Never>
        let followMember: AnyPublisher<Result<Int, Error>, Never>
        let stores: AnyPublisher<Result<[Store], Error>, Never>
        let reviews: AnyPublisher<Result<[Review], Error>, Never>
        let moreReviews: AnyPublisher<Result<[Review], Error>, Never>
        let isBookmark: AnyPublisher<Result<Int, Error>, Never>
    }
    
    // MARK: - init

    init(
        usecase: ProfileUsecase,
        memberId: Int
    ) {
        self.usecase = usecase
        self.memberId = memberId
    }
    
    // MARK: - Public - func
    
    func transform(from input: Input) -> Output {
        input.viewDidLoad
            .sink(receiveValue: { [weak self] _ in
                guard let self = self else { return }
                self.getMemberProfile(memberId: self.memberId)
            })
            .store(in: &self.cancellable)
        
        input.viewWillAppear
            .sink(receiveValue: { [weak self] _ in
                guard let self = self else { return }
                self.getMemberProfile(memberId: self.memberId)
            })
            .store(in: &self.cancellable)
        
        input.followMember
            .sink(receiveValue: { [weak self] memberId, isFollow in
                isFollow ? self?.unfollowMember(memberId: memberId) : self?.followMember(memberId: memberId)
            })
            .store(in: &self.cancellable)
        
        input.customLocation
            .debounce(for: .milliseconds(100), scheduler: RunLoop.main)
            .sink(receiveValue: { [weak self] location in
                guard let self = self else { return }
                self.location = location
                self.currentpageSize = self.pageSize
                self.lastReviewId = nil
                self.getReviewsByMember()
                self.getStoresByMember()
            })
            .store(in: &self.cancellable)
        
        input.bookmarkButtonDidTap
            .sink(receiveValue: { [weak self] storeId, isBookmark in
                guard let self = self else { return }
                isBookmark ? self.removeBookmark(storeId: storeId) : self.createBookmark(storeId: storeId)
            })
            .store(in: &self.cancellable)
        
        input.scrolledToBottom
            .sink(receiveValue: { [weak self] _ in
                guard let self = self else { return }
                self.getReviewsByMember(lastReviewId: self.lastReviewId)
            })
            .store(in: &self.cancellable)
        
        input.refreshControl
            .sink(receiveValue: { [weak self] _ in
                guard let self = self else { return }
                self.currentpageSize = self.pageSize
                self.lastReviewId = nil
                self.getReviewsByMember()
            })
            .store(in: &self.cancellable)
        
        return Output(
            member: memberSubject.eraseToAnyPublisher(),
            followMember: followMemberSubject.eraseToAnyPublisher(),
            stores: self.storesSubject.eraseToAnyPublisher(),
            reviews: self.reviewsSubject.eraseToAnyPublisher(),
            moreReviews: self.moreReviewsSubject.eraseToAnyPublisher(),
            isBookmark: self.isBookmarkSubject.eraseToAnyPublisher()
        )
    }
    
    // MARK: - network
    
    private func getMemberProfile(memberId: Int) {
        Task {
            do {
                let member = try await self.usecase.getMemberProfile(id: memberId)
                self.memberSubject.send(.success(member))
            } catch(let error) {
                self.memberSubject.send(.failure(error))
            }
        }
    }
    
    private func followMember(memberId: Int) {
        Task {
            do {
                try await self.usecase.followMember(memberId: memberId)
                self.followMemberSubject.send(.success(memberId))
            } catch(let error) {
                self.followMemberSubject.send(.failure(error))
            }
        }
    }
    
    private func unfollowMember(memberId: Int) {
        Task {
            do {
                try await self.usecase.unfollowMember(memberId: memberId)
                self.followMemberSubject.send(.success(memberId))
            } catch(let error) {
                self.followMemberSubject.send(.failure(error))
            }
        }
    }
    
    private func getReviewsByMember(lastReviewId: Int? = nil) {
        Task {
            do {
                guard let location = self.location else { return }
                if self.currentpageSize < self.pageSize { return }
                
                let reviews = try await self.usecase.getReviewsByMember(request: GetReviewsByMemberRequestDTO(
                    location: location,
                    lastReviewId: lastReviewId,
                    pageSize: self.pageSize,
                    memberId: memberId
                ))
                
                self.lastReviewId = reviews.page.lastId
                self.currentpageSize = reviews.page.size
                
                lastReviewId == nil ? self.reviewsSubject.send(.success(reviews.reviews)) : self.moreReviewsSubject.send(.success(reviews.reviews))
            } catch(let error) {
                self.reviewsSubject.send(.failure(error))
            }
        }
    }
    
    private func getStoresByMember() {
        Task {
            do {
                guard let location = self.location else { return }
                let stores = try await self.usecase.getStoresByMember(request: GetStoresByMemberRequestDTO(
                    location: location,
                    memberId: memberId
                ))
                self.storesSubject.send(.success(stores))
            } catch(let error) {
                self.storesSubject.send(.failure(error))
            }
        }
    }
    
    private func createBookmark(storeId: Int) {
        Task {
            do {
                try await self.usecase.createBookmark(storeId: storeId)
                self.isBookmarkSubject.send(.success(storeId))
            } catch(let error) {
                self.isBookmarkSubject.send(.failure(error))
            }
        }
    }
    
    private func removeBookmark(storeId: Int) {
        Task {
            do {
                try await self.usecase.removeBookmark(storeId: storeId)
                self.isBookmarkSubject.send(.success(storeId))
            } catch(let error) {
                self.isBookmarkSubject.send(.failure(error))
            }
        }
    }
}
