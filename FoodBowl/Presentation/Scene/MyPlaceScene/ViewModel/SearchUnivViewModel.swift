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
    
    private let univsSubject: PassthroughSubject<Result<[Store], Error>, Never> = PassthroughSubject()
    
    struct Input {
        let viewDidLoad: AnyPublisher<Void, Never>
    }
    
    struct Output {
        let univs: AnyPublisher<Result<[Store], Error>, Never>
    }
    
    // MARK: - init
    
    init(usecase: SearchPlaceUsecase) {
        self.usecase = usecase
    }
    
    // MARK: - Public - func
    
    func transform(from input: Input) -> Output {
        input.viewDidLoad
            .sink(receiveValue: { [weak self] _ in
                self?.getUnivs()
            })
            .store(in: &self.cancellable)
        
        return Output(
            univs: self.univsSubject.eraseToAnyPublisher()
        )
    }
    
    // MARK: - network
    
    private func getUnivs() {
        Task {
            do {
                let univs = try await self.usecase.getSchools()
                self.univsSubject.send(.success(univs))
            } catch(let error) {
                self.univsSubject.send(.failure(error))
            }
        }
    }
}
