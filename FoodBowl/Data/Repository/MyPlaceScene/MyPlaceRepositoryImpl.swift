//
//  MyPlaceRepositoryImpl.swift
//  FoodBowl
//
//  Created by Coby on 1/22/24.
//

import Foundation

import Moya

final class MyPlaceRepositoryImpl: MyPlaceRepository {
    
    private let provider = MoyaProvider<ServiceAPI>()
    
    func getReviewsBySchool(request: GetReviewsBySchoolRequestDTO) async throws -> ReviewDTO {
        let response = await provider.request(.getReviewsBySchool(request: request))
        return try response.decode()
    }
    
    func getStoresBySchool(request: GetStoresBySchoolRequestDTO) async throws -> StoreDTO {
        let response = await provider.request(.getStoresBySchool(request: request))
        return try response.decode()
    }
    
    func createBookmark(storeId: Int) async throws {
        let _ = await provider.request(.createBookmark(storeId: storeId))
    }
    
    func removeBookmark(storeId: Int) async throws {
        let _ = await provider.request(.removeBookmark(storeId: storeId))
    }
}
