//
//  KakaoRepository.swift
//  FoodBowl
//
//  Created by Coby on 12/30/23.
//

import Foundation

protocol KakaoRepository {
    func searchStores(x: String, y: String, keyword: String) async throws -> StoreBySearchDTO
    func searchUniv(x: String, y: String) async throws -> StoreDTO
}
