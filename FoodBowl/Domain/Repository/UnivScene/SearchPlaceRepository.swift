//
//  SearchPlaceRepository.swift
//  FoodBowl
//
//  Created by Coby on 1/22/24.
//

import Foundation

protocol SearchPlaceRepository {
    func getSchools() async throws -> SchoolDTO
}
