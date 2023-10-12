//
//  UnivViewModel.swift
//  FoodBowl
//
//  Created by COBY_PRO on 2023/09/18.
//

import UIKit

import Moya

final class UnivViewModel {
    private let providerService = MoyaProvider<ServiceAPI>()

    func getSchools() async -> [School] {
        let response = await providerService.request(.getSchools)
        switch response {
        case .success(let result):
            guard let data = try? result.map(SchoolResponse.self) else { return [School]() }
            return data.schools
        case .failure(let err):
            return [School]()
            print(err.localizedDescription)
        }
    }
}
