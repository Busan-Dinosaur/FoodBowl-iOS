//
//  UpdateReviewViewModel.swift
//  FoodBowl
//
//  Created by COBY_PRO on 2023/09/12.
//

import Combine
import Foundation

final class UpdateReviewViewModel: BaseViewModelType {
    
    // MARK: - property
    
    private let reviewId: Int
    
    private let usecase: UpdateReviewUsecase
    private var cancellable = Set<AnyCancellable>()
    
    private let reviewSubject: PassthroughSubject<Result<Review, Error>, Never> = PassthroughSubject()
    private let isCompletedSubject: PassthroughSubject<Result<Void, Error>, Never> = PassthroughSubject()
    
    struct Input {
        let viewDidLoad: AnyPublisher<Void, Never>
        let completeButtonDidTap: AnyPublisher<String, Never>
    }
    
    struct Output {
        let review: AnyPublisher<Result<Review, Error>, Never>
        let isCompleted: AnyPublisher<Result<Void, Error>, Never>
    }
    
    // MARK: - init

    init(
        usecase: UpdateReviewUsecase,
        reviewId: Int
    ) {
        self.usecase = usecase
        self.reviewId = reviewId
    }
    
    // MARK: - Public - func
    
    func transform(from input: Input) -> Output {
        input.viewDidLoad
            .sink(receiveValue: { [weak self] _ in
                self?.getReview()
            })
            .store(in: &self.cancellable)
        
        input.completeButtonDidTap
            .sink(receiveValue: { [weak self] comment in
                self?.updateReview(comment: comment)
            })
            .store(in: &self.cancellable)
        
        return Output(
            review: self.reviewSubject.eraseToAnyPublisher(),
            isCompleted: self.isCompletedSubject.eraseToAnyPublisher()
        )
    }
    
    // MARK: - network
    
    private func getReview() {
        Task {
            do {
                let deviceX = LocationManager.shared.manager.location?.coordinate.longitude ?? 0.0
                let deviceY = LocationManager.shared.manager.location?.coordinate.latitude ?? 0.0
                
                let review = try await self.usecase.getReview(request: GetReviewRequestDTO(
                    id: self.reviewId,
                    deviceX: deviceX,
                    deviceY: deviceY
                ))
                
                self.reviewSubject.send(.success(review))
            } catch(let error) {
                self.reviewSubject.send(.failure(error))
            }
        }
    }
    
    func updateReview(comment: String) {
        Task {
            do {
                try await self.usecase.updateReview(
                    id: self.reviewId,
                    request: UpdateReviewRequestDTO(
                        reviewContent: comment,
                        deletePhotoIds: []
                    ),
                    images: []
                )
                self.isCompletedSubject.send(.success(()))
            } catch(let error) {
                self.isCompletedSubject.send(.failure(error))
            }
        }
    }
}
