//
//  SearchUnivRepository.swift
//  FoodBowl
//
//  Created by Coby on 1/22/24.
//

import Foundation

protocol SearchUnivRepository {
    func getSchools() async throws -> SchoolDTO
}
