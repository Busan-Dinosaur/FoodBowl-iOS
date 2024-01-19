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
    
    private var store: Place?
    private var univ: Place?
    
    private let usecase: CreateReviewUsecase
    private var cancellable: Set<AnyCancellable> = Set()
    
    private let isCompletedSubject: PassthroughSubject<Result<Bool, Error>, Never> = PassthroughSubject()
    
    struct Input {
        let completeButtonDidTap: AnyPublisher<(String, [UIImage]), Never>
        let setStore: AnyPublisher<(Place, Place?), Never>
    }
    
    struct Output {
        let isCompleted: AnyPublisher<Result<Bool, Error>, Never>
    }
    
    func transform(from input: Input) -> Output {
        input.completeButtonDidTap
            .sink(receiveValue: { [weak self] comment, images in
                self?.createReview(comment: comment, images: images)
            })
            .store(in: &self.cancellable)
        
        input.setStore
            .sink(receiveValue: { [weak self] store, univ in
                self?.store = store
                self?.univ = univ
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
                            locationId: store.id,
                            storeName: store.name,
                            storeAddress: store.address,
                            x: Double(store.x)!,
                            y: Double(store.y)!,
                            storeUrl: store.url,
                            phone: store.phone,
                            category: store.category,
                            reviewContent: comment,
                            schoolName: univ.name,
                            schoolAddress: univ.address,
                            schoolX: Double(univ.x),
                            schoolY: Double(univ.y)
                        )
                    } else {
                        CreateReviewRequestDTO(
                            locationId: store.id,
                            storeName: store.name,
                            storeAddress: store.address,
                            x: Double(store.x)!,
                            y: Double(store.y)!,
                            storeUrl: store.url,
                            phone: store.phone,
                            category: store.category,
                            reviewContent: comment
                        )
                    }
                }
                let imagesData = images.map { $0.jpegData(compressionQuality: 0.3)! }
                try await self.usecase.createReview(request: request, images: imagesData)
                self.isCompletedSubject.send(.success(true))
            } catch {
                self.isCompletedSubject.send(.failure(NetworkError()))
            }
        }
    }
}
