//
//  BaseViewModel.swift
//  FoodBowl
//
//  Created by COBY_PRO on 10/16/23.
//

import UIKit

import Moya

class BaseViewModel {
    let pageSize = 10
    let size = 10

    let providerService = MoyaProvider<ServiceAPI>()
    let providerReview = MoyaProvider<ReviewAPI>()
    let providerStore = MoyaProvider<StoreAPI>()
    let providerMember = MoyaProvider<MemberAPI>()
    let providerFollow = MoyaProvider<FollowAPI>()
}

// MARK: - Review and Bookmark Method
extension BaseViewModel {
    func removeReview(id: Int) async -> Bool {
        let response = await providerReview.request(.removeReview(id: id))
        switch response {
        case .success:
            print("Success to Remove Review")
            return true
        case .failure(let err):
            print(err.localizedDescription)
            return false
        }
    }

    func createBookmark(storeId: Int) async -> Bool {
        let response = await providerStore.request(.createBookmark(storeId: storeId))
        switch response {
        case .success:
            print("Success to Create Bookmark")
            return true
        case .failure(let error):
            if let response = error.response {
                do {
                    // 서버에서 받은 데이터를 ErrorResponse 모델로 매핑
                    let errorResponse = try response.map(ErrorResponse.self)
                    print("에러 코드: \(errorResponse.errorCode)")
                    print("에러 메시지: \(errorResponse.message)")
                } catch {
                    print("에러 데이터 매핑에 실패했습니다.")
                }
            } else {
                print("네트워크 에러: \(error.localizedDescription)")
            }
            return false
        }
    }

    func removeBookmark(storeId: Int) async -> Bool {
        let response = await providerStore.request(.removeBookmark(storeId: storeId))
        switch response {
        case .success:
            print("Success to Remove Bookmark")
            return false
        case .failure(let err):
            print(err.localizedDescription)
            return true
        }
    }
}

// MARK: - Follow Method
extension BaseViewModel {
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
