//
//  SearchStoreViewModel.swift
//  FoodBowl
//
//  Created by Coby on 1/18/24.
//

import Combine
import UIKit

final class SearchStoreViewModel: NSObject, BaseViewModelType {
    
    // MARK: - property
    
    private let usecase: CreateReviewUsecase
    private var cancellable: Set<AnyCancellable> = Set()
    
    private let storesSubject = PassthroughSubject<[Place], Error>()
    private let isSelectedSubject: PassthroughSubject<Result<(Place, Place?), Error>, Never> = PassthroughSubject()
    
    struct Input {
        let searchStores: AnyPublisher<String, Never>
        let selectStore: AnyPublisher<Place, Never>
    }
    
    struct Output {
        let stores: PassthroughSubject<[Place], Error>
        let isSelected: AnyPublisher<Result<(Place, Place?), Error>, Never>
    }
    
    func transform(from input: Input) -> Output {
        input.searchStores
            .sink(receiveValue: { [weak self] keyword in
                self?.searchStores(keyword: keyword)
            })
            .store(in: &self.cancellable)
        
        input.selectStore
            .sink(receiveValue: { [weak self] store in
                self?.searchUniv(store: store)
            })
            .store(in: &self.cancellable)
        
        return Output(
            stores: self.storesSubject,
            isSelected: self.isSelectedSubject.eraseToAnyPublisher()
        )
    }
    
    // MARK: - init
    
    init(usecase: CreateReviewUsecase) {
        self.usecase = usecase
    }
    
    // MARK: - network
    
    private func searchStores(keyword: String) {
        Task {
            do {
                guard let location = LocationManager.shared.manager.location?.coordinate else { return }
                let deviceX = String(location.longitude)
                let deviceY = String(location.latitude)
                let stores = try await self.usecase.searchStores(x: deviceX, y: deviceY, keyword: keyword)
                self.storesSubject.send(stores)
            } catch {
                self.storesSubject.send(completion: .failure(error))
            }
        }
    }
    
    private func searchUniv(store: Place) {
        Task {
            do {
                let univ = try await self.usecase.searchUniv(x: store.x, y: store.y)
                self.isSelectedSubject.send(.success((store, univ)))
            } catch {
                self.isSelectedSubject.send(.failure(NetworkError()))
            }
        }
    }
}
