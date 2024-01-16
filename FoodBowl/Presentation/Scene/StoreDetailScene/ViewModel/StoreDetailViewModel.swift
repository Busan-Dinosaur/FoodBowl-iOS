//
//  StoreDetailViewModel.swift
//  FoodBowl
//
//  Created by COBY_PRO on 10/16/23.
//

import Combine
import UIKit

import CombineMoya
import Moya

final class StoreDetailViewModel: BaseViewModelType {
    
    // MARK: - property

    let provider = MoyaProvider<ServiceAPI>()
    
    private var cancelBag = Set<AnyCancellable>()
    
    var storeId: Int
    var isFriend: Bool
    
    private let pageSize: Int = 20
    private var currentpageSize: Int = 20
    private var lastReviewId: Int?
    private var reviews = [ReviewItemByStoreDTO]()
    
    private let reviewsSubject = PassthroughSubject<[ReviewItemByStoreDTO], Error>()
    private let refreshControlSubject = PassthroughSubject<Void, Error>()
    
    struct Input {
        let reviewToggleButtonDidTap: AnyPublisher<Bool, Never>
        let scrolledToBottom: AnyPublisher<Void, Never>
        let refreshControl: AnyPublisher<Void, Never>
    }
    
    struct Output {
        let reviews: PassthroughSubject<[ReviewItemByStoreDTO], Error>
        let refreshControl: PassthroughSubject<Void, Error>
    }
    
    // MARK: - init

    init(storeId: Int, isFriend: Bool) {
        self.storeId = storeId
        self.isFriend = isFriend
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
        if currentpageSize < pageSize { return }
        let filter = isFriend ? "FRIEND" : "ALL"
        
        provider.requestPublisher(
            .getReviewsByStore(request: GetReviewsByStoreRequestDTO(
                lastReviewId: lastReviewId,
                pageSize: self.pageSize,
                storeId: self.storeId,
                filter: filter
            ))
        )
        .sink { completion in
            switch completion {
            case let .failure(error):
                self.reviewsSubject.send(completion: .failure(error))
            case .finished:
                self.refreshControlSubject.send()
            }
        } receiveValue: { recievedValue in
            guard let responseData = try? recievedValue.map(ReviewByStoreDTO.self) else { return }
            self.lastReviewId = responseData.page.lastId
            self.currentpageSize = responseData.page.size
            
            if lastReviewId == nil {
                self.reviews = responseData.storeReviewContentResponses
            } else {
                self.reviews += responseData.storeReviewContentResponses
            }
            self.reviewsSubject.send(self.reviews)
        }
        .store(in : &cancelBag)
    }
    
    func removeReview(id: Int) async -> Bool {
        let response = await provider.request(.removeReview(id: id))
        switch response {
        case .success:
            return true
        case .failure(let err):
            handleError(err)
            return false
        }
    }
}
