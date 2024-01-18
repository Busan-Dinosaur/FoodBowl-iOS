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
    private var cancelBag = Set<AnyCancellable>()
    
    private let pageSize: Int = 20
    private var currentpageSize: Int = 20
    private var lastReviewId: Int?
    
    private let reviewsSubject = PassthroughSubject<[ReviewItem], Error>()
    private let moreReviewsSubject = PassthroughSubject<[ReviewItem], Error>()
    private let refreshControlSubject = PassthroughSubject<Void, Error>()
    private let storesSubject = PassthroughSubject<[Store], Error>()
    private let membersSubject = PassthroughSubject<[Member], Error>()
    
    struct Input {
        let scrolledToBottom: AnyPublisher<Void, Never>
        let refreshControl: AnyPublisher<Void, Never>
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
}
