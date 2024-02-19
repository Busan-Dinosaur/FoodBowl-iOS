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
    
    func getReviewsByBound(request: GetReviewsRequestDTO) async throws -> ReviewDTO {
        let response = await provider.request(.getReviewsByBound(request: request))
        return try response.decode()
    }
    
    func getStoresByBound(request: CustomLocationRequestDTO) async throws -> StoreDTO {
        let response = await provider.request(.getStoresByBound(request: request))
        return try response.decode()
    }
    
    func createBookmark(storeId: Int) async throws {
        let _ = await provider.request(.createBookmark(storeId: storeId))
    }
    
    func removeBookmark(storeId: Int) async throws {
        let _ = await provider.request(.removeBookmark(storeId: storeId))
    }
}
