//
//  SearchPlaceRepositoryImpl.swift
//  FoodBowl
//
//  Created by Coby on 1/22/24.
//

import Foundation

import Moya

final class SearchPlaceRepositoryImpl: SearchPlaceRepository {
    
    private let providerKakao = MoyaProvider<KakaoAPI>()
    
    func searchPlaces(x: String, y: String, keyword: String) async throws -> PlaceDTO {
        let response = await providerKakao.request(.searchPlaces(x: x, y: y, keyword: keyword))
        return try response.decode()
    }
}
