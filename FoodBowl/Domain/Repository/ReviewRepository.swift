//
//  ReviewRepository.swift
//  FoodBowl
//
//  Created by Coby on 12/29/23.
//

import Foundation

protocol ReviewRepository {
    func getReviewsByFollowing(request: GetReviewsRequestDTO) async throws -> ReviewDTO
    func getReviewsByBookmark(request: GetReviewsRequestDTO) async throws -> ReviewDTO
    func getReviewsByStore(request: GetReviewsByStoreRequestDTO) async throws -> ReviewByStoreDTO
    func getReviewsBySchool(request: GetReviewsBySchoolRequestDTO) async throws -> ReviewDTO
    func getReviewsByMember(request: GetReviewsByMemberRequestDTO) async throws -> ReviewDTO
    func createReview(request: CreateReviewRequestDTO) async throws
    func createBlame(request: CreateBlameRequestDTO) async throws
    func removeReview(id: Int) async throws
    func getSchools() async throws -> SchoolDTO
}
