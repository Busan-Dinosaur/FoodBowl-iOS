//
//  FindViewModel.swift
//  FoodBowl
//
//  Created by Coby on 1/19/24.
//

import Combine
import Foundation

final class FindViewModel: BaseViewModelType {
    
    // MARK: - property
    
    private let usecase: FindUsecase
    private var cancellable = Set<AnyCancellable>()
    
    private let pageSize: Int = 20
    private var currentpageSize: Int = 20
    private var lastReviewId: Int?
    
    private let size: Int = 20
    
    private let reviewsSubject = PassthroughSubject<[ReviewItem], Error>()
    private let moreReviewsSubject = PassthroughSubject<[ReviewItem], Error>()
    private let refreshControlSubject = PassthroughSubject<Void, Error>()
    
    private let storesSubject = PassthroughSubject<[Store], Error>()
    private let membersSubject = PassthroughSubject<[Member], Error>()
    
    struct Input {
        let scrolledToBottom: AnyPublisher<Void, Never>
        let refreshControl: AnyPublisher<Void, Never>
        let searchStores: AnyPublisher<String, Never>
        let searchMembers: AnyPublisher<String, Never>
        let followMember: AnyPublisher<(Int, Bool), Never>
    }
    
    struct Output {
        let reviews: PassthroughSubject<[ReviewItem], Error>
        let moreReviews: PassthroughSubject<[ReviewItem], Error>
        let stores: PassthroughSubject<[Store], Error>
        let members: PassthroughSubject<[Member], Error>
    }
    
    // MARK: - init

    init(usecase: FindUsecase) {
        self.usecase = usecase
    }
    
    // MARK: - Public - func
    
    func transform(from input: Input) -> Output {
        self.getReviews()
        
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
        
        input.searchStores
            .sink(receiveValue: { [weak self] keyword in
                self?.searchStores(keyword: keyword)
            })
            .store(in: &self.cancellable)
        
        input.searchMembers
            .sink(receiveValue: { [weak self] keyword in
                self?.searchMembers(keyword: keyword)
            })
            .store(in: &self.cancellable)
        
        input.followMember
            .sink(receiveValue: { [weak self] memberId, isFollow in
                isFollow ? self?.unfollowMember(memberId: memberId) : self?.followMember(memberId: memberId)
            })
            .store(in: &self.cancellable)
        
        return Output(
            reviews: reviewsSubject,
            moreReviews: moreReviewsSubject,
            stores: storesSubject,
            members: membersSubject
        )
    }
    
    // MARK: - network
    
    private func getReviews(lastReviewId: Int? = nil) {
        Task {
            do {
                if currentpageSize < pageSize { return }
                let deviceX = LocationManager.shared.manager.location?.coordinate.longitude ?? 0.0
                let deviceY = LocationManager.shared.manager.location?.coordinate.latitude ?? 0.0
                
                let review = try await self.usecase.getReviewsByFeed(request: GetReviewsByFeedRequestDTO(
                    lastReviewId: lastReviewId,
                    pageSize: self.pageSize,
                    deviceX: deviceX,
                    deviceY: deviceY
                ))
                
                self.lastReviewId = review.page.lastId
                self.currentpageSize = review.page.size
                
                lastReviewId == nil ? self.reviewsSubject.send(review.reviews) : self.moreReviewsSubject.send(review.reviews)
            } catch {
                self.reviewsSubject.send(completion: .failure(error))
            }
        }
    }
    
    private func searchStores(keyword: String) {
        Task {
            do {
                guard let location = LocationManager.shared.manager.location?.coordinate else { return }
                let deviceX = location.longitude
                let deviceY = location.latitude
                let stores = try await self.usecase.getStoresBySearch(request: SearchStoreRequestDTO(
                    name: keyword,
                    x: deviceX,
                    y: deviceY,
                    size: self.size
                ))
                self.storesSubject.send(stores)
            } catch {
                self.storesSubject.send(completion: .failure(error))
            }
        }
    }
    
    private func searchMembers(keyword: String) {
        Task {
            do {
                let members = try await self.usecase.getMembersBySearch(request: SearchMemberRequestDTO(
                    name: keyword,
                    size: self.size
                ))
                self.membersSubject.send(members)
            } catch {
                self.membersSubject.send(completion: .failure(error))
            }
        }
    }
    
    private func followMember(memberId: Int) {
        Task {
            do {
                try await self.usecase.followMember(memberId: memberId)
            } catch {
                print("Failed to Follow Member")
            }
        }
    }
    
    private func unfollowMember(memberId: Int) {
        Task {
            do {
                try await self.usecase.unfollowMember(memberId: memberId)
            } catch {
                print("Failed to Unfollow Member")
            }
        }
    }
}
