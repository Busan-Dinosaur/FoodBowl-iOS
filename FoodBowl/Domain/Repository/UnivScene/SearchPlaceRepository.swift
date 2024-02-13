//
//  SearchPlaceRepository.swift
//  FoodBowl
//
//  Created by Coby on 1/22/24.
//

import Foundation

protocol SearchPlaceRepository {
    func searchPlaces(x: String, y: String, keyword: String) async throws -> PlaceDTO
}
