//
//  Place.swift
//  FoodBowl
//
//  Created by Coby Kim on 2023/01/13.
//

import Foundation

// MARK: - Response

struct Response: Codable {
    let documents: [Place]
    let meta: Meta
}

// MARK: - Document

struct Place: Codable {
    let addressName: String
    let categoryGroupCode: String
    let categoryGroupName: String
    let categoryName: String
    let distance, id, phone, placeName: String
    let placeURL: String
    let roadAddressName, longitude, latitude: String

    enum CodingKeys: String, CodingKey {
        case addressName = "address_name"
        case categoryGroupCode = "category_group_code"
        case categoryGroupName = "category_group_name"
        case categoryName = "category_name"
        case distance, id, phone
        case placeName = "place_name"
        case placeURL = "place_url"
        case roadAddressName = "road_address_name"
        case longitude = "x"
        case latitude = "y"
    }
}

// MARK: - Meta

struct Meta: Codable {
    let isEnd: Bool
    let pageableCount: Int
    let totalCount: Int

    enum CodingKeys: String, CodingKey {
        case isEnd = "is_end"
        case pageableCount = "pageable_count"
        case totalCount = "total_count"
    }
}
