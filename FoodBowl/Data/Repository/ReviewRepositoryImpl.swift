//
//  ReviewRepositoryImpl.swift
//  FoodBowl
//
//  Created by Coby on 12/29/23.
//

import Foundation

import Moya

final class ReviewRepositoryImpl: ReviewRepository {

    private let provider = MoyaProvider<ServiceAPI>()

    func getReviewsByFollowing(request: GetReviewsRequestDTO) async throws -> ReviewDTO {
        let response = await provider.request(.getReviewsByFollowing(request: request))
        return try response.decode()
    }
    
    func getReviewsByBookmark(request: GetReviewsRequestDTO) async throws -> ReviewDTO {
        let response = await provider.request(.getReviewsByBookmark(request: request))
        return try response.decode()
    }
    
    func getReviewsByStore(request: GetReviewsByStoreRequestDTO) async throws -> ReviewByStoreDTO {
        let response = await provider.request(.getReviewsByStore(request: request))
        return try response.decode()
    }
    
    func getReviewsBySchool(request: GetReviewsBySchoolRequestDTO) async throws -> ReviewDTO {
        let response = await provider.request(.getReviewsBySchool(request: request))
        return try response.decode()
    }
    
    func getReviewsByMember(request: GetReviewsByMemberRequestDTO) async throws -> ReviewDTO {
        let response = await provider.request(.getReviewsByMember(request: request))
        return try response.decode()
    }
    
    func createReview(request: CreateReviewRequestDTO, images: [Data]) async throws {
        let _ = await provider.request(.createReview(request: request, images: images))
    }
    
    func createBlame(request: CreateBlameRequestDTO) async throws {
        let _ = await provider.request(.createBlame(request: request))
    }
    
    func removeReview(id: Int) async throws {
        let _ = await provider.request(.removeReview(id: id))
    }
    
    func getSchools() async throws -> SchoolDTO {
        let response = await provider.request(.getSchools)
        return try response.decode()
    }
}
