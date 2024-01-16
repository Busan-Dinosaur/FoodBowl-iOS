//
//  BlameViewModel.swift
//  FoodBowl
//
//  Created by Coby on 12/31/23.
//

import Combine
import Foundation

final class BlameViewModel: NSObject, BaseViewModelType {
    
    // MARK: - property
    
    private let targetId: Int
    private let blameTarget: String
    
    private let usecase: BlameUsecase
    private var cancellable: Set<AnyCancellable> = Set()
    
    private let isCompletedSubject: PassthroughSubject<Result<Bool, Error>, Never> = PassthroughSubject()
    
    struct Input {
        let completeButtonDidTap: AnyPublisher<String, Never>
    }
    
    struct Output {
        let isCompleted: AnyPublisher<Result<Bool, Error>, Never>
    }
    
    func transform(from input: Input) -> Output {
        input.completeButtonDidTap
            .sink(receiveValue: { [weak self] description in
                self?.createBlame(description: description)
            })
            .store(in: &self.cancellable)
        
        return Output(isCompleted: self.isCompletedSubject.eraseToAnyPublisher())
    }
    
    // MARK: - init
    
    init(targetId: Int, blameTarget: String, usecase: BlameUsecase) {
        self.targetId = targetId
        self.blameTarget = blameTarget
        self.usecase = usecase
    }
    
    // MARK: - network
    
    private func createBlame(description: String) {
        Task {
            do {
                try await self.usecase.createBlame(request: CreateBlameRequestDTO(
                    targetId: self.targetId,
                    blameTarget: self.blameTarget,
                    description: description
                ))
            } catch {
                self.isCompletedSubject.send(.failure(NetworkError()))
            }
        }
    }
}
