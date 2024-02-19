//
//  SearchMyPlaceViewModel.swift
//  FoodBowl
//
//  Created by Coby on 1/22/24.
//

import Combine
import UIKit

final class SearchMyPlaceViewModel: NSObject, BaseViewModelType {
    
    // MARK: - property
    
    private let usecase: SearchPlaceUsecase
    private var cancellable: Set<AnyCancellable> = Set()
    
    private let placesSubject: PassthroughSubject<Result<[Store], Error>, Never> = PassthroughSubject()
    
    struct Input {
        let searchPlaces: AnyPublisher<String, Never>
    }
    
    struct Output {
        let places: AnyPublisher<Result<[Store], Error>, Never>
    }
    
    // MARK: - init
    
    init(usecase: SearchPlaceUsecase) {
        self.usecase = usecase
    }
    
    // MARK: - Public - func
    
    func transform(from input: Input) -> Output {
        input.searchPlaces
            .removeDuplicates()
            .sink(receiveValue: { [weak self] keyword in
                self?.searchPlaces(keyword: keyword)
            })
            .store(in: &self.cancellable)
        
        return Output(
            places: self.placesSubject.eraseToAnyPublisher()
        )
    }
    
    // MARK: - network
    
    private func searchPlaces(keyword: String) {
        Task {
            do {
                guard let location = LocationManager.shared.manager.location?.coordinate else { return }
                let deviceX = String(location.longitude)
                let deviceY = String(location.latitude)
                let places = try await self.usecase.searchPlaces(x: deviceX, y: deviceY, keyword: keyword)
                self.placesSubject.send(.success(places))
            } catch(let error) {
                self.placesSubject.send(.failure(error))
            }
        }
    }
}
