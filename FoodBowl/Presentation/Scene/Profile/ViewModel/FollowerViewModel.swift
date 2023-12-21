//
//  FollowerViewModel.swift
//  FoodBowl
//
//  Created by Coby on 12/21/23.
//

import Combine
import UIKit

import CombineMoya
import Moya

final class FollowerViewModel: NSObject, BaseViewModelType {
    
    // MARK: - property
    
    private let provider = MoyaProvider<ServiceAPI>()
    private var cancelBag = Set<AnyCancellable>()
    
    private let isOwn: Bool
    private let memberId: Int
    
    private let size: Int = 20
    private var currentPage: Int = 0
    private var currentSize: Int = 20
    private var followers = [MemberByFollow]()
    
    private let followersSubject = PassthroughSubject<[MemberByFollow], Error>()
    
    struct Input {
        let scrolledToBottom: AnyPublisher<Void, Never>
    }
    
    struct Output {
        let followers: PassthroughSubject<[MemberByFollow], Error>
    }
    
    // MARK: - init

    init(memberId: Int) {
        self.memberId = memberId
        self.isOwn = UserDefaultsManager.currentUser?.id ?? 0 == memberId
    }
    
    // MARK: - Public - func
    
    func transform(from input: Input) -> Output {
        self.getFollowersPublisher(page: self.currentPage)
        
        input.scrolledToBottom
            .sink(receiveValue: { [weak self] _ in
                guard let self = self else { return }
                self.getFollowersPublisher(page: self.currentPage)
            })
            .store(in: &self.cancelBag)
        
        return Output(
            followers: followersSubject
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
            return false
        case .failure(let err):
            handleError(err)
            return true
        }
    }
    
    private func getFollowersPublisher(page: Int = 0) {
        if currentSize < size { return }
        
        provider.requestPublisher(
            .getFollowerMember(
                memberId: memberId,
                page: page,
                size: size
            )
        )
        .sink { completion in
            switch completion {
            case let .failure(error):
                self.followersSubject.send(completion: .failure(error))
            case .finished:
                break
            }
        } receiveValue: { recievedValue in
            guard let responseData = try? recievedValue.map(FollowMemberResponse.self) else { return }
            self.currentPage = responseData.currentPage
            self.currentSize = responseData.currentSize
            
            if page == 0 {
                self.followers = responseData.content
            } else {
                self.followers += responseData.content
            }
            self.followersSubject.send(self.followers)
        }
        .store(in : &cancelBag)
    }}
