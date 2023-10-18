//
//  ProfileViewModel.swift
//  FoodBowl
//
//  Created by COBY_PRO on 2023/09/09.
//

import UIKit

import Moya

final class ProfileViewModel: BaseViewModel {}

// MARK: - Get and Update Profile
extension ProfileViewModel {
    func getMemberProfile(id: Int) async -> MemberProfileResponse? {
        let response = await providerMember.request(.getMemberProfile(id: id))
        switch response {
        case .success(let result):
            guard let data = try? result.map(MemberProfileResponse.self) else { return nil }
            return data
        case .failure(let err):
            handleError(err)
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
            handleError(err)
        }
    }

    func updateMembeProfileImage(image: UIImage) async {
        guard let imageData = image.jpegData(compressionQuality: 0.1) else { return }
        let response = await providerMember.request(.updateMemberProfileImage(image: imageData))
        switch response {
        case .success:
            return
        case .failure(let err):
            handleError(err)
        }
    }
}

// MARK: - Get Reviews and Stores
extension ProfileViewModel {
    func getReviews(location: CustomLocation, memberId: Int, lastReviewId: Int? = nil) async -> [Review] {
        print("--------출력이다------")
        let response = await providerReview.request(
            .getReviewsByMember(
                form: location,
                memberId: memberId,
                lastReviewId: lastReviewId,
                pageSize: pageSize
            )
        )
        switch response {
        case .success(let result):
            guard let data = try? result.map(ReviewResponse.self) else { return [] }
            self.lastReviewId = data.page.lastId
            currentpageSize = data.page.size
            return data.reviews
        case .failure(let err):
            handleError(err)
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
            handleError(err)
            return []
        }
    }
}
