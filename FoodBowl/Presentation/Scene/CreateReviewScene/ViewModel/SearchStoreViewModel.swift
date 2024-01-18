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
    
    private let storesSubject = PassthroughSubject<[PlaceItemDTO], Error>()
    private let isSelectedSubject: PassthroughSubject<Result<(PlaceItemDTO, PlaceItemDTO?), Error>, Never> = PassthroughSubject()
    
    struct Input {
        let searchStores: AnyPublisher<String, Never>
        let selectStore: AnyPublisher<PlaceItemDTO, Never>
    }
    
    struct Output {
        let stores: PassthroughSubject<[PlaceItemDTO], Error>
        let isSelected: AnyPublisher<Result<(PlaceItemDTO, PlaceItemDTO?), Error>, Never>
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
    
    func searchStores(keyword: String) {
        Task {
            do {
                let deviceX = String(LocationManager.shared.manager.location?.coordinate.longitude ?? 0.0)
                let deviceY = String(LocationManager.shared.manager.location?.coordinate.latitude ?? 0.0)
                let stores = try await self.usecase.searchStores(x: deviceX, y: deviceY, keyword: keyword)
                self.storesSubject.send(stores)
            } catch {
                self.storesSubject.send(completion: .failure(error))
            }
        }
    }
    
    func searchUniv(store: PlaceItemDTO) {
        Task {
            do {
                let univ = try await self.usecase.searchUniv(x: store.longitude, y: store.latitude)
                self.isSelectedSubject.send(.success((store, univ)))
            } catch {
                print("Failed to Search Univ")
                self.isSelectedSubject.send(.failure(NetworkError()))
            }
        }
    }
}
