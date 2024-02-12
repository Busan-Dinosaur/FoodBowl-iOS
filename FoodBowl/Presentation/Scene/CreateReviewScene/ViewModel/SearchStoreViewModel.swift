//
//  SearchStoreViewModel.swift
//  FoodBowl
//
//  Created by Coby on 1/18/24.
//

import Combine
import UIKit
import MapKit

final class SearchStoreViewModel: NSObject, BaseViewModelType {
    
    // MARK: - property
    
    private var location: CLLocationCoordinate2D? = nil
    
    private let usecase: CreateReviewUsecase
    private var cancellable: Set<AnyCancellable> = Set()
    
    private let storesSubject: PassthroughSubject<Result<[Store], Error>, Never> = PassthroughSubject()
    private let isSelectedSubject: PassthroughSubject<Result<(Store, Store?), Error>, Never> = PassthroughSubject()
    
    struct Input {
        let searchStores: AnyPublisher<String, Never>
        let selectStore: AnyPublisher<Store, Never>
    }
    
    struct Output {
        let stores: AnyPublisher<Result<[Store], Error>, Never>
        let isSelected: AnyPublisher<Result<(Store, Store?), Error>, Never>
    }
    
    func transform(from input: Input) -> Output {
        input.searchStores
            .removeDuplicates()
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
            stores: self.storesSubject.eraseToAnyPublisher(),
            isSelected: self.isSelectedSubject.eraseToAnyPublisher()
        )
    }
    
    // MARK: - init
    
    init(
        usecase: CreateReviewUsecase,
        location: CLLocationCoordinate2D?
    ) {
        self.usecase = usecase
        self.location = location
    }
    
    // MARK: - network
    
    private func searchStores(keyword: String) {
        Task {
            do {
                guard let location = LocationManager.shared.manager.location?.coordinate else { return }
                let deviceX = String(location.longitude)
                let deviceY = String(location.latitude)
                let stores = try await self.usecase.searchStores(x: deviceX, y: deviceY, keyword: keyword)
                self.storesSubject.send(.success(stores))
            } catch(let error) {
                self.storesSubject.send(.failure(error))
            }
        }
    }
    
    private func searchUniv(store: Store) {
        Task {
            do {
                let univ = try await self.usecase.searchUniv(x: String(store.x), y: String(store.y))
                self.isSelectedSubject.send(.success((store, univ)))
            } catch(let error) {
                self.isSelectedSubject.send(.failure(error))
            }
        }
    }
}
