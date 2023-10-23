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
    let providerFollow = MoyaProvider<FollowAPI>()
    
    private var cancelBag = Set<AnyCancellable>()
    
    private var customLocation: CustomLocation?
    
    var type: MapViewType = .friend
    
    private let pageSize: Int = 2
    private var currentpageSize: Int = 2
    
    private var lastReviewId: Int?
    private var schoolId: Int?
    private var memberId: Int?
    
    private var reviews = [Review]()
    
    private let reviewsSubject = PassthroughSubject<[Review], Error>()
    private let refreshControlSubject = PassthroughSubject<Void, Error>()
    
    struct Input {
        let customLocation: AnyPublisher<CustomLocation, Never>
        let scrolledToBottom: AnyPublisher<Void, Never>
        let refreshControl: AnyPublisher<Void, Never>
    }
    
    struct Output {
        let reviews: PassthroughSubject<[Review], Error>
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
                    self.getReviewsByFollowing()
                case .univ:
                    self.getReviewsByFollowing()
                case .member:
                    self.getReviewsByFollowing()
                }
            })
            .store(in: &self.cancelBag)
        
        input.scrolledToBottom
            .sink(receiveValue: { [weak self] _ in
                guard let self = self else { return }
                
                switch self.type {
                case .friend:
                    self.getReviewsByFollowing(lastReviewId: self.lastReviewId)
                case .univ:
                    self.getReviewsByFollowing(lastReviewId: self.lastReviewId)
                case .member:
                    self.getReviewsByFollowing(lastReviewId: self.lastReviewId)
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
                    self.getReviewsByFollowing()
                case .univ:
                    self.getReviewsByFollowing()
                case .member:
                    self.getReviewsByFollowing()
                }
            })
            .store(in: &self.cancelBag)
        
        return Output(
            reviews: reviewsSubject,
            refreshControl: refreshControlSubject
        )
    }
}

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
            case let .failure(error):
                self.reviewsSubject.send(completion: .failure(error))
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
}
