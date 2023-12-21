//
//  FollowingViewModel.swift
//  FoodBowl
//
//  Created by Coby on 12/21/23.
//

import Combine
import UIKit

import CombineMoya
import Moya

final class FollowingViewModel: NSObject, BaseViewModelType {
    
    // MARK: - property
    
    private let provider = MoyaProvider<ServiceAPI>()
    private var cancelBag = Set<AnyCancellable>()
    
    private let isOwn: Bool
    private let memberId: Int
    
    private let size: Int = 20
    private var currentPage: Int = 0
    private var currentSize: Int = 20
    
    private let followingsSubject = PassthroughSubject<[MemberByFollow], Error>()
    private let moreFollowingsSubject = PassthroughSubject<[MemberByFollow], Error>()
    
    struct Input {
        let viewDidLoad: AnyPublisher<Void, Never>
        let scrolledToBottom: AnyPublisher<Void, Never>
    }
    
    struct Output {
        let followings: PassthroughSubject<[MemberByFollow], Error>
        let moreFollowings: PassthroughSubject<[MemberByFollow], Error>
    }
    
    // MARK: - init

    init(memberId: Int) {
        self.memberId = memberId
        self.isOwn = UserDefaultsManager.currentUser?.id ?? 0 == memberId
    }
    
    // MARK: - Public - func
    
    func transform(from input: Input) -> Output {
        let viewDidLoad = input.viewDidLoad
            .compactMap { [weak self] in self?.getFollowingsPublisher() }
            .eraseToAnyPublisher()
        
        input.scrolledToBottom
            .sink(receiveValue: { [weak self] _ in
                guard let self = self else { return }
                self.getFollowingsPublisher()
            })
            .store(in: &self.cancelBag)
        
        return Output(
            followings: followingsSubject,
            moreFollowings: moreFollowingsSubject
        )
    }
}

// MARK: - network
extension FollowingViewModel {
    func followMember(memberId: Int) async -> Bool {
        let response = await provider.request(.followMember(memberId: memberId))
        switch response {
        case .success:
            return true
        case .failure(let err):
            handleError(err)
            return false
        }
    }
    
    func unfollowMember(memberId: Int) async -> Bool {
        let response = await provider.request(.unfollowMember(memberId: memberId))
        switch response {
        case .success:
            return false
        case .failure(let err):
            handleError(err)
            return true
        }
    }
    
    private func getFollowingsPublisher() {
        if currentSize < size { return }
        
        provider.requestPublisher(
            .getFollowingMember(
                memberId: memberId,
                page: currentPage,
                size: size
            )
        )
        .sink { completion in
            switch completion {
            case let .failure(error):
                self.followingsSubject.send(completion: .failure(error))
            case .finished:
                break
            }
        } receiveValue: { recievedValue in
            guard let responseData = try? recievedValue.map(FollowMemberResponse.self) else { return }
            self.currentPage = responseData.currentPage
            self.currentSize = responseData.currentSize
            
            if self.currentPage == 0 {
                self.followingsSubject.send(responseData.content)
            } else {
                self.moreFollowingsSubject.send(responseData.content)
            }
            
        }
        .store(in : &cancelBag)
    }
}
