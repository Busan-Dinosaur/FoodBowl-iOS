//
//  ProfileViewModel.swift
//  FoodBowl
//
//  Created by COBY_PRO on 2023/09/09.
//

import UIKit

import Moya

final class ProfileViewModel {
    private let pageSize = 10

    private let providerService = MoyaProvider<ServiceAPI>()
    private let providerReview = MoyaProvider<ReviewAPI>()
    private let providerStore = MoyaProvider<StoreAPI>()
    private let providerMember = MoyaProvider<MemberAPI>()
    private let providerFollow = MoyaProvider<FollowAPI>()
}

// MARK: - Get and Update Profile
extension ProfileViewModel {
    func getMemberProfile(id: Int) async -> MemberProfileResponse? {
        let response = await providerMember.request(.getMemberProfile(id: id))
        switch response {
        case .success(let result):
            guard let data = try? result.map(MemberProfileResponse.self) else { return nil }
            return data
        case .failure(let err):
            print(err.localizedDescription)
            return nil
        }
    }

    func updateMembeProfile(profile: UpdateMemberProfileRequest) async {
        let response = await providerMember.request(.updateMemberProfile(request: profile))
        switch response {
        case .success:
            if var currentUser = UserDefaultsManager.currentUser {
                currentUser.nickname = profile.nickname
                currentUser.introduction = profile.introduction
                UserDefaultsManager.currentUser = currentUser
            }
        case .failure(let err):
            print(err.localizedDescription)
        }
    }

    func updateMembeProfileImage(image: UIImage) async {
        guard let imageData = image.jpegData(compressionQuality: 0.1) else { return }
        let response = await providerMember.request(.updateMemberProfileImage(image: imageData))
        switch response {
        case .success:
            print("success")
        case .failure(let err):
            print(err.localizedDescription)
        }
    }
}

// MARK: - Get Member's Reviews and Stores
extension ProfileViewModel {
    func getReviews(location: CustomLocation, memberId: Int) async -> [Review] {
        let response = await providerReview.request(
            .getReviewsByMember(
                form: location,
                memberId: memberId,
                lastReviewId: nil,
                pageSize: pageSize
            )
        )
        switch response {
        case .success(let result):
            guard let data = try? result.map(ReviewResponse.self) else { return [] }
            return data.reviews
        case .failure(let err):
            print(err.localizedDescription)
            return []
        }
    }

    func getStores(location: CustomLocation, memberId: Int) async -> [Store] {
        let response = await providerStore.request(.getStoresByMember(form: location, memberId: memberId))
        switch response {
        case .success(let result):
            guard let data = try? result.map(StoreResponse.self) else { return [] }
            return data.stores
        case .failure(let err):
            print(err.localizedDescription)
            return []
        }
    }
}

// MARK: - Follow Method
extension ProfileViewModel {
    func followMember(memberId: Int) async -> Bool {
        let response = await providerFollow.request(.followMember(memberId: memberId))
        switch response {
        case .success:
            print("Success to Follow")
            return true
        case .failure(let err):
            print(err.localizedDescription)
            return false
        }
    }

    func unfollowMember(memberId: Int) async -> Bool {
        let response = await providerFollow.request(.unfollowMember(memberId: memberId))
        switch response {
        case .success:
            print("Success to Unfollow")
            return false
        case .failure(let err):
            print(err.localizedDescription)
            return true
        }
    }
}
