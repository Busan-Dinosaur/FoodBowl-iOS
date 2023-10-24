//
//  MapViewModel.swift
//  FoodBowl
//
//  Created by COBY_PRO on 10/12/23.
//

import Combine
import UIKit

import CombineMoya
import Moya

final class MapViewModel: BaseViewModelType {
    
    // MARK: - property

    let providerReview = MoyaProvider<ReviewAPI>()
    let providerStore = MoyaProvider<StoreAPI>()
    let providerFollow = MoyaProvider<FollowAPI>()
    
    private var cancelBag = Set<AnyCancellable>()
    
    private let pageSize: Int = 2
    private let size: Int = 2
    private var currentpageSize: Int = 2
    private var lastReviewId: Int?

    var customLocation: CustomLocation?
    var type: MapViewType = .friend
    var isBookmark: Bool = false
    var schoolId: Int?
    var memberId: Int?
    
    private var reviews = [Review]()
    private var stores = [Store]()
    
    private let reviewsSubject = PassthroughSubject<[Review], Error>()
    private let storesSubject = PassthroughSubject<[Store], Error>()
    private let refreshControlSubject = PassthroughSubject<Void, Error>()
    
    struct Input {
        let customLocation: AnyPublisher<CustomLocation, Never>
        let scrolledToBottom: AnyPublisher<Void, Never>
        let refreshControl: AnyPublisher<Void, Never>
        let bookmarkButtonDidTap: AnyPublisher<StoreByReview, Never>
    }
    
    struct Output {
        let reviews: PassthroughSubject<[Review], Error>
        let stores: PassthroughSubject<[Store], Error>
        let refreshControl: PassthroughSubject<Void, Error>
    }
    
    // MARK: - Public - func
    
    func transform(from input: Input) -> Output {
        input.customLocation
            .sink(receiveValue: { [weak self] customLocation in
                guard let self = self else { return }
                self.customLocation = customLocation
                self.currentpageSize = self.pageSize
                self.lastReviewId = nil
                
                switch self.type {
                case .friend:
                    self.isBookmark ? self.getReviewsByBookmark() : self.getReviewsByFollowing()
                    self.isBookmark ? self.getStoresByBookmark() : self.getStoresByFollowing()
                case .univ:
                    self.getReviewsBySchool()
                    self.getStoresBySchool()
                case .member:
                    self.getReviewsByMember()
                    self.getStoresByMember()
                }
            })
            .store(in: &self.cancelBag)
        
        input.scrolledToBottom
            .sink(receiveValue: { [weak self] _ in
                guard let self = self else { return }
                
                switch self.type {
                case .friend:
                    self.isBookmark ? self.getReviewsByBookmark(lastReviewId: self.lastReviewId) : self.getReviewsByFollowing(lastReviewId: self.lastReviewId)
                case .univ:
                    self.getReviewsBySchool(lastReviewId: self.lastReviewId)
                case .member:
                    self.getReviewsByMember(lastReviewId: self.lastReviewId)
                }
            })
            .store(in: &self.cancelBag)
        
        input.refreshControl
            .sink(receiveValue: { [weak self] _ in
                guard let self = self else { return }
                self.currentpageSize = self.pageSize
                self.lastReviewId = nil                
                
                switch self.type {
                case .friend:
                    self.isBookmark ? self.getReviewsByBookmark() : self.getReviewsByFollowing()
                case .univ:
                    self.getReviewsBySchool()
                case .member:
                    self.getReviewsByMember()
                }
            })
            .store(in: &self.cancelBag)
        
        input.bookmarkButtonDidTap
            .sink(receiveValue: { [weak self] store in
                guard let self = self else { return }
                store.isBookmarked ? self.removeBookmark(storeId: store.id) : self.createBookmark(storeId: store.id)
            })
            .store(in: &self.cancelBag)
        
        return Output(
            reviews: reviewsSubject,
            stores: storesSubject,
            refreshControl: refreshControlSubject
        )
    }
}

// MARK: - Review Method
extension MapViewModel {
    private func getReviewsByFollowing(lastReviewId: Int? = nil) {
        if currentpageSize < pageSize { return }
        guard let customLocation = customLocation else { return }
        
        providerReview.requestPublisher(
            .getReviewsByFollowing(
                form: customLocation,
                lastReviewId: lastReviewId,
                pageSize: self.pageSize
            )
        )
        .sink { completion in
            switch completion {
            case .failure:
                self.reviews = []
                self.reviewsSubject.send([])
            case .finished:
                self.refreshControlSubject.send()
            }
        } receiveValue: { recievedValue in
            guard let responseData = try? recievedValue.map(ReviewResponse.self) else { return }
            self.lastReviewId = responseData.page.lastId
            self.currentpageSize = responseData.page.size
            
            if lastReviewId == nil {
                self.reviews = responseData.reviews
            } else {
                self.reviews += responseData.reviews
            }
            
            self.reviewsSubject.send(self.reviews)
        }
        .store(in : &cancelBag)
    }
    
    private func getReviewsByBookmark(lastReviewId: Int? = nil) {
        if currentpageSize < pageSize { return }
        guard let customLocation = customLocation else { return }
        
        providerReview.requestPublisher(
            .getReviewsByBookmark(
                form: customLocation,
                lastReviewId: lastReviewId,
                pageSize: self.pageSize
            )
        )
        .sink { completion in
            switch completion {
            case .failure:
                self.reviews = []
                self.reviewsSubject.send([])
            case .finished:
                self.refreshControlSubject.send()
            }
        } receiveValue: { recievedValue in
            guard let responseData = try? recievedValue.map(ReviewResponse.self) else { return }
            self.lastReviewId = responseData.page.lastId
            self.currentpageSize = responseData.page.size
            
            if lastReviewId == nil {
                self.reviews = responseData.reviews
            } else {
                self.reviews += responseData.reviews
            }
            
            self.reviewsSubject.send(self.reviews)
        }
        .store(in : &cancelBag)
    }
    
    private func getReviewsBySchool(lastReviewId: Int? = nil) {
        if currentpageSize < pageSize { return }
        guard let customLocation = customLocation, let schoolId = schoolId else { return }
        
        providerReview.requestPublisher(
            .getReviewsBySchool(
                form: customLocation,
                schoolId: schoolId,
                lastReviewId: lastReviewId,
                pageSize: self.pageSize
            )
        )
        .sink { completion in
            switch completion {
            case .failure:
                self.reviews = []
                self.reviewsSubject.send([])
            case .finished:
                self.refreshControlSubject.send()
            }
        } receiveValue: { recievedValue in
            guard let responseData = try? recievedValue.map(ReviewResponse.self) else { return }
            self.lastReviewId = responseData.page.lastId
            self.currentpageSize = responseData.page.size
            
            if lastReviewId == nil {
                self.reviews = responseData.reviews
            } else {
                self.reviews += responseData.reviews
            }
            
            self.reviewsSubject.send(self.reviews)
        }
        .store(in : &cancelBag)
    }
    
    private func getReviewsByMember(lastReviewId: Int? = nil) {
        if currentpageSize < pageSize { return }
        guard let customLocation = customLocation, let memberId = memberId else { return }
        
        providerReview.requestPublisher(
            .getReviewsByMember(
                form: customLocation,
                memberId: memberId,
                lastReviewId: lastReviewId,
                pageSize: self.pageSize
            )
        )
        .sink { completion in
            switch completion {
            case .failure:
                self.reviews = []
                self.reviewsSubject.send([])
            case .finished:
                self.refreshControlSubject.send()
            }
        } receiveValue: { recievedValue in
            guard let responseData = try? recievedValue.map(ReviewResponse.self) else { return }
            self.lastReviewId = responseData.page.lastId
            self.currentpageSize = responseData.page.size
            
            if lastReviewId == nil {
                self.reviews = responseData.reviews
            } else {
                self.reviews += responseData.reviews
            }
            
            self.reviewsSubject.send(self.reviews)
        }
        .store(in : &cancelBag)
    }
    
    func removeReview(id: Int) {
        providerReview.requestPublisher(.removeReview(id: id))
            .sink { completion in
                switch completion {
                case let .failure(error):
                    print("")
                case .finished:
                    print("")
                }
            } receiveValue: { _ in
            }
            .store(in : &cancelBag)
    }
}

// MARK: - Store Method
extension MapViewModel {
    func getStoresByFollowing() {
        guard let customLocation = customLocation else { return }
        providerStore.requestPublisher(.getStoresByFollowing(form: customLocation))
            .sink { completion in
                switch completion {
                case .failure:
                    self.stores = []
                    self.storesSubject.send([])
                case .finished:
                    print("스토어")
                }
            } receiveValue: { recievedValue in
                guard let responseData = try? recievedValue.map(StoreResponse.self) else { return }
                self.stores = responseData.stores
                self.storesSubject.send(responseData.stores)
            }
            .store(in : &cancelBag)
    }
    
    func getStoresByBookmark() {
        guard let customLocation = customLocation else { return }
        providerStore.requestPublisher(.getStoresByBookmark(form: customLocation))
            .sink { completion in
                switch completion {
                case .failure:
                    self.stores = []
                    self.storesSubject.send([])
                case .finished:
                    print("스토어")
                }
            } receiveValue: { recievedValue in
                guard let responseData = try? recievedValue.map(StoreResponse.self) else { return }
                self.stores = responseData.stores
                self.storesSubject.send(responseData.stores)
            }
            .store(in : &cancelBag)
    }
    
    func getStoresBySchool() {
        guard let customLocation = customLocation, let schoolId = schoolId else { return }
        providerStore.requestPublisher(.getStoresBySchool(form: customLocation, schoolId: schoolId))
            .sink { completion in
                switch completion {
                case .failure:
                    self.stores = []
                    self.storesSubject.send([])
                case .finished:
                    print("스토어")
                }
            } receiveValue: { recievedValue in
                guard let responseData = try? recievedValue.map(StoreResponse.self) else { return }
                self.stores = responseData.stores
                self.storesSubject.send(responseData.stores)
            }
            .store(in : &cancelBag)
    }
    
    func getStoresByMember() {
        guard let customLocation = customLocation, let memberId = memberId else { return }
        providerStore.requestPublisher(.getStoresByMember(form: customLocation, memberId: memberId))
            .sink { completion in
                switch completion {
                case .failure:
                    self.stores = []
                    self.storesSubject.send([])
                case .finished:
                    print("스토어")
                }
            } receiveValue: { recievedValue in
                guard let responseData = try? recievedValue.map(StoreResponse.self) else { return }
                self.stores = responseData.stores
                self.storesSubject.send(responseData.stores)
            }
            .store(in : &cancelBag)
    }
    
    func createBookmark(storeId: Int) {
        providerStore.requestPublisher(.createBookmark(storeId: storeId))
            .sink { completion in
                switch completion {
                case .failure:
                    print("")
                case .finished:
                    self.reviewsSubject.send(self.reviews)
                }
            } receiveValue: { _ in
                self.reviews = self.reviews.map {
                    var review = $0
                    if review.store.id == storeId {
                        review.store.isBookmarked.toggle()
                    }
                    return review
                }
            }
            .store(in : &cancelBag)
    }

    func removeBookmark(storeId: Int) {
        providerStore.requestPublisher(.removeBookmark(storeId: storeId))
            .sink { completion in
                switch completion {
                case .failure:
                    print("")
                case .finished:
                    self.reviewsSubject.send(self.reviews)
                }
            } receiveValue: { _ in
                self.reviews = self.reviews.map {
                    var review = $0
                    if review.store.id == storeId {
                        review.store.isBookmarked.toggle()
                    }
                    return review
                }
            }
            .store(in : &cancelBag)
    }
}

// MARK: - Follow Method
extension MapViewModel {
    func followMember(memberId: Int) {
        providerFollow.requestPublisher(.followMember(memberId: memberId))
            .sink { completion in
                switch completion {
                case let .failure(error):
                    print("")
                case .finished:
                    print("")
                }
            } receiveValue: { _ in
            }
            .store(in : &cancelBag)
    }

    func unfollowMember(memberId: Int) {
        providerFollow.requestPublisher(.unfollowMember(memberId: memberId))
            .sink { completion in
                switch completion {
                case let .failure(error):
                    print("")
                case .finished:
                    print("")
                }
            } receiveValue: { _ in
            }
            .store(in : &cancelBag)
    }

    func getFollowerMembers(memberId: Int, page: Int = 0) {
        providerFollow.requestPublisher(
            .getFollowerMember(
                memberId: memberId,
                page: page,
                size: size
            )
        )
        .sink { completion in
            switch completion {
            case let .failure(error):
                print("")
            case .finished:
                print("")
            }
        } receiveValue: { recievedValue in
            guard let responseData = try? recievedValue.map(FollowMemberResponse.self) else { return }
        }
        .store(in : &cancelBag)
    }
    
    func getFollowingMembers(memberId: Int, page: Int = 0) {
        providerFollow.requestPublisher(
            .getFollowingMember(
                memberId: memberId,
                page: page,
                size: size
            )
        )
        .sink { completion in
            switch completion {
            case let .failure(error):
                print("")
            case .finished:
                print("")
            }
        } receiveValue: { recievedValue in
            guard let responseData = try? recievedValue.map(FollowMemberResponse.self) else { return }
        }
        .store(in : &cancelBag)
    }

    func removeFollowingMember(memberId: Int) {
        providerFollow.requestPublisher(.removeFollower(memberId: memberId))
            .sink { completion in
                switch completion {
                case let .failure(error):
                    print("")
                case .finished:
                    print("")
                }
            } receiveValue: { _ in
            }
            .store(in : &cancelBag)
    }
}
