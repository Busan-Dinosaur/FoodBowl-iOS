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
    
    var store: PlaceItemDTO?
    var univ: PlaceItemDTO?
    
    private let usecase: CreateReviewUsecase
    private var cancellable: Set<AnyCancellable> = Set()
    
    private let isCompletedSubject: PassthroughSubject<Result<Bool, Error>, Never> = PassthroughSubject()
    
    struct Input {
        let completeButtonDidTap: AnyPublisher<(String, [UIImage]), Never>
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
                
                try await self.usecase.createReview(request: CreateReviewRequestDTO(
                    locationId: store.id,
                    storeName: store.placeName,
                    storeAddress: store.roadAddressName,
                    x: Double(store.longitude) ?? 0.0,
                    y: Double(store.latitude) ?? 0.0,
                    storeUrl: store.placeURL,
                    phone: store.phone,
                    category: store.getCategory(),
                    reviewContent: comment,
                    schoolName: self.univ?.placeName,
                    schoolAddress: self.univ?.roadAddressName,
                    schoolX: Double(self.univ?.longitude ?? ""),
                    schoolY: Double(self.univ?.latitude ?? ""),
                    images: imagesData
                ))
                
                self.isCompletedSubject.send(.success(true))
            } catch {
                self.isCompletedSubject.send(.failure(NetworkError()))
            }
        }
    }
}
