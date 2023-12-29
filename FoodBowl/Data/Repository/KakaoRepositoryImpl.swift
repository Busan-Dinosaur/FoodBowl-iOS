//
//  KakaoRepositoryImpl.swift
//  FoodBowl
//
//  Created by Coby on 12/30/23.
//

import Foundation

import Moya

final class KakaoRepositoryImpl: KakaoRepository {
    
    private let provider = MoyaProvider<KakaoAPI>()
    
    func searchStores(x: String, y: String, keyword: String) async throws -> StoreBySearchDTO {
        let response = await provider.request(.searchStores(x: x, y: y, keyword: keyword))
        return try response.decode()
    }
    
    func searchUniv(x: String, y: String) async throws -> StoreDTO {
        let response = await provider.request(.searchUniv(x: x, y: y))
        return try response.decode()
    }
}
