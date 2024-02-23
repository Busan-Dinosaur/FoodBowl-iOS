//
//  CreateReviewViewModel.swift
//  FoodBowl
//
//  Created by COBY_PRO on 2023/09/10.
//

import Combine
import UIKit
import MapKit

final class CreateReviewViewModel: NSObject, BaseViewModelType {
    
    // MARK: - property
    
    private var reviewImages: [UIImage] = []
    var location: CLLocationCoordinate2D? = nil
    private var store: Store?
    
    private let usecase: CreateReviewUsecase
    private var cancellable: Set<AnyCancellable> = Set()
    
    private let isCompletedSubject: PassthroughSubject<Result<Void, Error>, Never> = PassthroughSubject()
    
    struct Input {
        let setStore: AnyPublisher<Store, Never>
        let completeButtonDidTap: AnyPublisher<String, Never>
    }
    
    struct Output {
        let isCompleted: AnyPublisher<Result<Void, Error>, Never>
    }
    
    func transform(from input: Input) -> Output {
        input.setStore
            .sink(receiveValue: { [weak self] store in
                self?.store = store
            })
            .store(in: &self.cancellable)
        
        input.completeButtonDidTap
            .throttle(for: .milliseconds(1000), scheduler: RunLoop.main, latest: false)
            .sink(receiveValue: { [weak self] comment in
                self?.createReview(comment: comment)
            })
            .store(in: &self.cancellable)
        
        return Output(
            isCompleted: self.isCompletedSubject.eraseToAnyPublisher()
        )
    }
    
    // MARK: - init
    
    init(
        usecase: CreateReviewUsecase,
        reviewImages: [UIImage],
        location: CLLocationCoordinate2D?
    ) {
        self.usecase = usecase
        self.reviewImages = reviewImages
        self.location = location
    }
    
    // MARK: - network
    
    private func createReview(comment: String) {
        Task {
            do {
                guard let store = self.store else { return }
                var request: CreateReviewRequestDTO {
                    CreateReviewRequestDTO(
                        locationId: String(store.id),
                        storeName: store.name,
                        storeAddress: store.address,
                        x: store.x,
                        y: store.y,
                        storeUrl: store.url,
                        phone: store.phone,
                        category: store.category,
                        reviewContent: comment
                    )
                }
                let imagesData = self.reviewImages.map { $0.jpegData(compressionQuality: 0.3)! }
                try await self.usecase.createReview(request: request, images: imagesData)
                self.isCompletedSubject.send(.success(()))
            } catch(let error) {
                self.isCompletedSubject.send(.failure(error))
            }
        }
    }
}
