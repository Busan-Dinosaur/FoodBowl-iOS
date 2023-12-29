//
//  StoreRepositoryImpl.swift
//  FoodBowl
//
//  Created by Coby on 12/30/23.
//

import Foundation

import Moya

final class StoreRepositoryImpl: StoreRepository {

    private let provider = MoyaProvider<ServiceAPI>()
    
    func getStoresBySearch(request: SearchStoreRequestDTO) async throws -> StoreBySearchDTO {
        let response = await provider.request(.getStoresBySearch(request: request))
        return try response.decode()
    }
    
    func getStoresBySchool(request: GetStoresBySchoolRequestDTO) async throws -> StoreDTO {
        let response = await provider.request(.getStoresBySchool(request: request))
        return try response.decode()
    }
    
    func getStoresByMember(request: GetStoresByMemberRequestDTO) async throws -> StoreDTO {
        let response = await provider.request(.getStoresByMember(request: request))
        return try response.decode()
    }
    
    func getStoresByFollowing(request: CustomLocationRequestDTO) async throws -> StoreDTO {
        let response = await provider.request(.getStoresByFollowing(request: request))
        return try response.decode()
    }
    
    func getStoresByBookmark(request: CustomLocationRequestDTO) async throws -> StoreDTO {
        let response = await provider.request(.getStoresByBookmark(request: request))
        return try response.decode()
    }
    
    func createBookmark(storeId: Int) async throws {
        let response = await provider.request(.createBookmark(storeId: storeId))
    }
    
    func removeBookmark(storeId: Int) async throws {
        let response = await provider.request(.removeBookmark(storeId: storeId))
    }
}
