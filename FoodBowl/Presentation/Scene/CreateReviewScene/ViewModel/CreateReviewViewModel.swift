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
    
    private var store: PlaceItemDTO?
    private var univ: PlaceItemDTO?
    
    private let usecase: CreateReviewUsecase
    private var cancellable: Set<AnyCancellable> = Set()
    
    private let isCompletedSubject: PassthroughSubject<Result<Bool, Error>, Never> = PassthroughSubject()
    
    struct Input {
        let completeButtonDidTap: AnyPublisher<(String, [UIImage]), Never>
        let setStore: AnyPublisher<(PlaceItemDTO, PlaceItemDTO?), Never>
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
                let imagesData = images.map { $0.jpegData(compressionQuality: 0.3)! }
                var request: CreateReviewRequestDTO {
                    if let univ = self.univ {
                        CreateReviewRequestDTO(
                            locationId: store.id,
                            storeName: store.placeName,
                            storeAddress: store.roadAddressName,
                            x: Double(store.longitude)!,
                            y: Double(store.latitude)!,
                            storeUrl: store.placeURL,
                            phone: store.phone,
                            category: store.getCategory(),
                            reviewContent: comment,
                            schoolName: univ.placeName,
                            schoolAddress: univ.roadAddressName,
                            schoolX: Double(univ.longitude),
                            schoolY: Double(univ.latitude),
                            images: imagesData
                        )
                    } else {
                        CreateReviewRequestDTO(
                            locationId: store.id,
                            storeName: store.placeName,
                            storeAddress: store.roadAddressName,
                            x: Double(store.longitude)!,
                            y: Double(store.latitude)!,
                            storeUrl: store.placeURL,
                            phone: store.phone,
                            category: store.getCategory(),
                            reviewContent: comment,
                            images: imagesData
                        )
                    }
                }
                
                try await self.usecase.createReview(request: request)
                self.isCompletedSubject.send(.success(true))
            } catch {
                self.isCompletedSubject.send(.failure(NetworkError()))
            }
        }
    }
}
