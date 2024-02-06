//
//  SearchUnivRepositoryImpl.swift
//  FoodBowl
//
//  Created by Coby on 1/22/24.
//

import Foundation

import Moya

final class SearchUnivRepositoryImpl: SearchUnivRepository {
    
    private let provider = MoyaProvider<ServiceAPI>()
    
    func getSchools() async throws -> SchoolDTO {
        let response = await provider.request(.getSchools)
        return try response.decode()
    }
}
