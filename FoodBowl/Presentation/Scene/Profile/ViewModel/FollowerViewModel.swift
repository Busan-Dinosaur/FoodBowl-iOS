//
//  FollowerViewModel.swift
//  FoodBowl
//
//  Created by Coby on 12/21/23.
//

import Combine
import UIKit

import Moya

final class FollowerViewModel: NSObject, BaseViewModelType {
    
    typealias Task = _Concurrency.Task
    
    // MARK: - property
    
    private let provider = MoyaProvider<ServiceAPI>()
    private var cancellable = Set<AnyCancellable>()
    
    let isOwn: Bool
    private let memberId: Int
    
    private let size: Int = 20
    private var currentPage: Int = 0
    private var currentSize: Int = 20
    
    private let followersSubject = PassthroughSubject<[MemberByFollowItemDTO], Error>()
    private let moreFollowersSubject = PassthroughSubject<[MemberByFollowItemDTO], Error>()
    
    struct Input {
        let viewDidLoad: AnyPublisher<Void, Never>
        let scrolledToBottom: AnyPublisher<Void, Never>
    }
    
    struct Output {
        let followers: PassthroughSubject<[MemberByFollowItemDTO], Error>
        let moreFollowers: PassthroughSubject<[MemberByFollowItemDTO], Error>
    }
    
    // MARK: - init

    init(memberId: Int) {
        self.memberId = memberId
        self.isOwn = UserDefaultStorage.id == memberId
    }
    
    // MARK: - Public - func
    
    func transform(from input: Input) -> Output {
        input.viewDidLoad
            .sink(receiveValue: { [weak self] _ in
                guard let self = self else { return }
                self.getFollowers()
            })
            .store(in: &self.cancellable)
        
        input.scrolledToBottom
            .sink(receiveValue: { [weak self] _ in
                guard let self = self else { return }
                self.getFollowers()
            })
            .store(in: &self.cancellable)
        
        return Output(
            followers: followersSubject,
            moreFollowers: moreFollowersSubject
        )
    }
}

// MARK: - network
extension FollowerViewModel {
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
            return true
        case .failure(let err):
            handleError(err)
            return false
        }
    }
    
    func removeFollowingMember(memberId: Int) async -> Bool {
        let response = await provider.request(.removeFollower(memberId: memberId))
        switch response {
        case .success:
            return true
        case .failure(let err):
            handleError(err)
            return false
        }
    }
    
    private func getFollowers() {
        Task {
            if currentSize < size { return }
            
            let response = await self.provider.request(
                .getFollowerMember(
                    memberId: memberId,
                    page: currentPage,
                    size: size
                )
            )
            switch response {
            case .success(let result):
                guard let data = try? result.map(MemberByFollowDTO.self) else { return }
                self.currentPage = data.currentPage
                self.currentSize = data.currentSize
                
                if self.currentPage == 0 {
                    self.followersSubject.send(data.content)
                } else {
                    self.moreFollowersSubject.send(data.content)
                }
            case .failure(let err):
                handleError(err)
            }
        }
    }
}