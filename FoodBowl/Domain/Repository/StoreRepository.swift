//
//  StoreRepository.swift
//  FoodBowl
//
//  Created by Coby on 12/29/23.
//

import Foundation

protocol StoreRepository {
    func getStoresBySearch(request: SearchStoreRequestDTO) async throws -> StoreBySearchDTO
    func getStoresBySchool(request: GetStoresBySchoolRequestDTO) async throws -> StoreDTO
    func getStoresByMember(request: GetStoresByMemberRequestDTO) async throws -> StoreDTO
    func getStoresByFollowing(request: CustomLocationRequestDTO) async throws -> StoreDTO
    func getStoresByBookmark(request: CustomLocationRequestDTO) async throws -> StoreDTO
    func createBookmark(storeId: Int) async throws
    func removeBookmark(storeId: Int) async throws
}
