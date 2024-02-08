//
//  CreateReviewViewModel.swift
//  FoodBowl
//
//  Created by COBY_PRO on 2023/09/10.
//

import Combine
import UIKit

final class CreateReviewViewModel: NSObject, BaseViewModelType {
    
    // MARK: - property
    
    private var store: Store?
    private var univ: Store?
    
    private let usecase: CreateReviewUsecase
    private var cancellable: Set<AnyCancellable> = Set()
    
    private let isCompletedSubject: PassthroughSubject<Result<Void, Error>, Never> = PassthroughSubject()
    
    struct Input {
        let setStore: AnyPublisher<(Store, Store?), Never>
        let completeButtonDidTap: AnyPublisher<(String, [UIImage]), Never>
    }
    
    struct Output {
        let isCompleted: AnyPublisher<Result<Void, Error>, Never>
    }
    
    func transform(from input: Input) -> Output {
        input.setStore
            .sink(receiveValue: { [weak self] store, univ in
                self?.store = store
                self?.univ = univ
            })
            .store(in: &self.cancellable)
        
        input.completeButtonDidTap
            .debounce(for: .milliseconds(100), scheduler: RunLoop.main)
            .sink(receiveValue: { [weak self] comment, images in
                self?.createReview(comment: comment, images: images)
            })
            .store(in: &self.cancellable)
        
        return Output(
            isCompleted: self.isCompletedSubject.eraseToAnyPublisher()
        )
    }
    
    // MARK: - init
    
    init(usecase: CreateReviewUsecase) {
        self.usecase = usecase
    }
    
    // MARK: - network
    
    private func createReview(comment: String, images: [UIImage]) {
        Task {
            do {
                guard let store = self.store else { return }
                var request: CreateReviewRequestDTO {
                    if let univ = self.univ {
                        CreateReviewRequestDTO(
                            locationId: String(store.id),
                            storeName: store.name,
                            storeAddress: store.address,
                            x: store.x,
                            y: store.y,
                            storeUrl: store.url,
                            phone: store.phone,
                            category: store.category,
                            reviewContent: comment,
                            schoolName: univ.name,
                            schoolAddress: univ.address,
                            schoolX: univ.x,
                            schoolY: univ.y
                        )
                    } else {
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
                }
                let imagesData = images.map { $0.jpegData(compressionQuality: 0.3)! }
                try await self.usecase.createReview(request: request, images: imagesData)
                self.isCompletedSubject.send(.success(()))
            } catch(let error) {
                self.isCompletedSubject.send(.failure(error))
            }
        }
    }
}
