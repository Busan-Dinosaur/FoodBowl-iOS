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
    
    typealias Task = _Concurrency.Task
    
    // MARK: - property

    let providerReview = MoyaProvider<ReviewAPI>()
    let providerStore = MoyaProvider<StoreAPI>()
    let providerFollow = MoyaProvider<FollowAPI>()
    let providerMember = MoyaProvider<MemberAPI>()
    
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
    
    private let reviewsSubject = PassthroughSubject<[Review], Error>()
    private let moreReviewsSubject = PassthroughSubject<[Review], Error>()
    private let storesSubject = PassthroughSubject<[Store], Error>()
    private let refreshControlSubject = PassthroughSubject<Void, Error>()
    private let bookmarkStoreSubject = PassthroughSubject<Int, Error>()
    
    struct Input {
        let customLocation: AnyPublisher<CustomLocation, Never>
        let scrolledToBottom: AnyPublisher<Void, Never>
        let refreshControl: AnyPublisher<Void, Never>
        let bookmarkButtonDidTap: AnyPublisher<StoreByReview, Never>
    }
    
    struct Output {
        let reviews: PassthroughSubject<[Review], Error>
        let moreReviews: PassthroughSubject<[Review], Error>
        let stores: PassthroughSubject<[Store], Error>
        let refreshControl: PassthroughSubject<Void, Error>
        let bookmarkStore: PassthroughSubject<Int, Error>
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
            moreReviews: moreReviewsSubject,
            stores: storesSubject,
            refreshControl: refreshControlSubject,
            bookmarkStore: bookmarkStoreSubject
        )
    }
}

// MARK: - Review Method
extension MapViewModel {
    private func getReviewsByFollowing(lastReviewId: Int? = nil) {
        Task {
            if currentpageSize < pageSize { return }
            guard let customLocation = customLocation else { return }
            
            let response = await self.providerReview.request(
                .getReviewsByFollowing(
                    form: customLocation,
                    lastReviewId: lastReviewId,
                    pageSize: self.pageSize
                )
            )
            switch response {
            case .success(let result):
                guard let data = try? result.map(ReviewResponse.self) else { return }
                self.lastReviewId = data.page.lastId
                self.currentpageSize = data.page.size
                
                lastReviewId == nil ? self.reviewsSubject.send(data.reviews) : self.moreReviewsSubject.send(data.reviews)
            case .failure(let err):
                handleError(err)
            }
        }
    }
    
    private func getReviewsByBookmark(lastReviewId: Int? = nil) {
        Task {
            if currentpageSize < pageSize { return }
            guard let customLocation = customLocation else { return }
            
            let response = await self.providerReview.request(
                .getReviewsByBookmark(
                    form: customLocation,
                    lastReviewId: lastReviewId,
                    pageSize: self.pageSize
                )
            )
            switch response {
            case .success(let result):
                guard let data = try? result.map(ReviewResponse.self) else { return }
                self.lastReviewId = data.page.lastId
                self.currentpageSize = data.page.size
                
                lastReviewId == nil ? self.reviewsSubject.send(data.reviews) : self.moreReviewsSubject.send(data.reviews)
            case .failure(let err):
                handleError(err)
            }
            self.refreshControlSubject.send()
        }
    }
    
    private func getReviewsBySchool(lastReviewId: Int? = nil) {
        Task {
            if currentpageSize < pageSize { return }
            guard let customLocation = customLocation, let schoolId = schoolId else { return }
            
            let response = await self.providerReview.request(
                .getReviewsBySchool(
                    form: customLocation,
                    schoolId: schoolId,
                    lastReviewId: lastReviewId,
                    pageSize: self.pageSize
                )
            )
            switch response {
            case .success(let result):
                guard let data = try? result.map(ReviewResponse.self) else { return }
                self.lastReviewId = data.page.lastId
                self.currentpageSize = data.page.size
                
                lastReviewId == nil ? self.reviewsSubject.send(data.reviews) : self.moreReviewsSubject.send(data.reviews)
            case .failure(let err):
                handleError(err)
            }
            self.refreshControlSubject.send()
        }
    }
    
    private func getReviewsByMember(lastReviewId: Int? = nil) {
        Task {
            if currentpageSize < pageSize { return }
            guard let customLocation = customLocation, let memberId = memberId else { return }
            
            let response = await self.providerReview.request(
                .getReviewsByMember(
                    form: customLocation,
                    memberId: memberId,
                    lastReviewId: lastReviewId,
                    pageSize: self.pageSize
                )
            )
            switch response {
            case .success(let result):
                guard let data = try? result.map(ReviewResponse.self) else { return }
                self.lastReviewId = data.page.lastId
                self.currentpageSize = data.page.size
                
                lastReviewId == nil ? self.reviewsSubject.send(data.reviews) : self.moreReviewsSubject.send(data.reviews)
            case .failure(let err):
                handleError(err)
            }
            self.refreshControlSubject.send()
        }
    }
    
    private func removeReview(id: Int) {
        Task {
            let response = await providerReview.request(.removeReview(id: id))
            switch response {
            case .success:
                return
            case .failure(let err):
                handleError(err)
            }
        }
    }
}

// MARK: - Store Method
extension MapViewModel {
    func getStoresByFollowing() {
        Task {
            guard let customLocation = customLocation else { return }
            
            let response = await providerStore.request(.getStoresByFollowing(form: customLocation))
            switch response {
            case .success(let result):
                guard let data = try? result.map(StoreResponse.self) else { return }
                self.storesSubject.send(data.stores)
            case .failure(let err):
                handleError(err)
            }
        }
    }
    
    func getStoresByBookmark() {
        Task {
            guard let customLocation = customLocation else { return }
            
            let response = await providerStore.request(.getStoresByBookmark(form: customLocation))
            switch response {
            case .success(let result):
                guard let data = try? result.map(StoreResponse.self) else { return }
                self.storesSubject.send(data.stores)
            case .failure(let err):
                handleError(err)
            }
        }
    }
    
    func getStoresBySchool() {
        Task {
            guard let customLocation = customLocation, let schoolId = schoolId else { return }
            
            let response = await providerStore.request(.getStoresBySchool(form: customLocation, schoolId: schoolId))
            switch response {
            case .success(let result):
                guard let data = try? result.map(StoreResponse.self) else { return }
                self.storesSubject.send(data.stores)
            case .failure(let err):
                handleError(err)
            }
        }
    }
    
    func getStoresByMember() {
        Task {
            guard let customLocation = customLocation, let memberId = memberId else { return }
            
            let response = await providerStore.request(.getStoresByMember(form: customLocation, memberId: memberId))
            switch response {
            case .success(let result):
                guard let data = try? result.map(StoreResponse.self) else { return }
                self.storesSubject.send(data.stores)
            case .failure(let err):
                handleError(err)
            }
        }
    }
    
    func createBookmark(storeId: Int) {
        Task {
            let response = await providerStore.request(.createBookmark(storeId: storeId))
            switch response {
            case .success:
                self.bookmarkStoreSubject.send(storeId)
            case .failure(let err):
                handleError(err)
            }
        }
    }
    
    func removeBookmark(storeId: Int) {
        Task {
            let response = await providerStore.request(.removeBookmark(storeId: storeId))
            switch response {
            case .success:
                self.bookmarkStoreSubject.send(storeId)
            case .failure(let err):
                handleError(err)
            }
        }
    }
}

// MARK: - Follow Method
extension MapViewModel {
    func followMember(memberId: Int) async -> Bool {
        let response = await providerFollow.request(.followMember(memberId: memberId))
        switch response {
        case .success:
            return true
        case .failure(let err):
            handleError(err)
            return false
        }
    }

    func unfollowMember(memberId: Int) async -> Bool {
        let response = await providerFollow.request(.unfollowMember(memberId: memberId))
        switch response {
        case .success:
            return true
        case .failure(let err):
            handleError(err)
            return false
        }
    }

    func getFollowerMembers(memberId: Int, page: Int = 0) async -> [MemberByFollow] {
        let response = await providerFollow.request(
            .getFollowerMember(
                memberId: memberId,
                page: page,
                size: size
            )
        )
        switch response {
        case .success(let result):
            guard let data = try? result.map(FollowMemberResponse.self) else { return [] }
            return data.content
        case .failure(let err):
            handleError(err)
            return []
        }
    }

    func getFollowingMembers(memberId: Int, page: Int = 0) async -> [MemberByFollow] {
        let response = await providerFollow.request(
            .getFollowingMember(
                memberId: memberId,
                page: page,
                size: size
            )
        )
        switch response {
        case .success(let result):
            guard let data = try? result.map(FollowMemberResponse.self) else { return [] }
            return data.content
        case .failure(let err):
            handleError(err)
            return []
        }
    }

    func removeFollowingMember(memberId: Int) async -> Bool {
        let response = await providerFollow.request(.removeFollower(memberId: memberId))
        switch response {
        case .success:
            return true
        case .failure(let err):
            handleError(err)
            return false
        }
    }
}

// MARK: - Get and Update Profile
extension MapViewModel {
    func getMemberProfile(id: Int) async -> MemberProfileResponse? {
        let response = await providerMember.request(.getMemberProfile(id: id))
        switch response {
        case .success(let result):
            guard let data = try? result.map(MemberProfileResponse.self) else { return nil }
            return data
        case .failure(let err):
            handleError(err)
            return nil
        }
    }

    func updateMembeProfile(profile: UpdateMemberProfileRequest) async {
        let response = await providerMember.request(.updateMemberProfile(request: profile))
        switch response {
        case .success:
            if var currentUser = UserDefaultsManager.currentUser {
                currentUser.nickname = profile.nickname
                currentUser.introduction = profile.introduction
                UserDefaultsManager.currentUser = currentUser
            }
        case .failure(let err):
            handleError(err)
        }
    }

    func updateMembeProfileImage(image: UIImage) async {
        guard let imageData = image.jpegData(compressionQuality: 0.1) else { return }
        let response = await providerMember.request(.updateMemberProfileImage(image: imageData))
        switch response {
        case .success:
            return
        case .failure(let err):
            handleError(err)
        }
    }
}
