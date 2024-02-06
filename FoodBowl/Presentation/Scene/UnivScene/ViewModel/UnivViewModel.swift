//
//  UnivViewModel.swift
//  FoodBowl
//
//  Created by Coby on 1/22/24.
//

import Combine
import Foundation

final class UnivViewModel: BaseViewModelType {
    
    // MARK: - property
    
    private var category: CategoryType?
    
    private var location: CustomLocationRequestDTO?
    private let pageSize: Int = 20
    private var currentpageSize: Int = 20
    private var lastReviewId: Int?
    
    private let usecase: UnivUsecase
    private var cancellable = Set<AnyCancellable>()
    
    private let univSubject: PassthroughSubject<(String, Double, Double), Never> = PassthroughSubject()
    private let storesSubject: PassthroughSubject<Result<[Store], Error>, Never> = PassthroughSubject()
    private let reviewsSubject: PassthroughSubject<Result<[Review], Error>, Never> = PassthroughSubject()
    private let moreReviewsSubject: PassthroughSubject<Result<[Review], Error>, Never> = PassthroughSubject()
    private let refreshControlSubject: PassthroughSubject<Void, Error> = PassthroughSubject()
    private let isBookmarkedSubject: PassthroughSubject<Result<Int, Error>, Never> = PassthroughSubject()
    
    struct Input {
        let viewDidLoad: AnyPublisher<Void, Never>
        let setCategory: AnyPublisher<CategoryType?, Never>
        let setUniv: AnyPublisher<Store, Never>
        let customLocation: AnyPublisher<CustomLocationRequestDTO, Never>
        let bookmarkButtonDidTap: AnyPublisher<(Int, Bool), Never>
        let scrolledToBottom: AnyPublisher<Void, Never>
        let refreshControl: AnyPublisher<Void, Never>
    }
    
    struct Output {
        let univ: AnyPublisher<(String, Double, Double), Never>
        let stores: AnyPublisher<Result<[Store], Error>, Never>
        let reviews: AnyPublisher<Result<[Review], Error>, Never>
        let moreReviews: AnyPublisher<Result<[Review], Error>, Never>
        let isBookmarked: AnyPublisher<Result<Int, Error>, Never>
    }
    
    // MARK: - init

    init(usecase: UnivUsecase) {
        self.usecase = usecase
    }
    
    // MARK: - Public - func
    
    func transform(from input: Input) -> Output {
        input.viewDidLoad
            .sink(receiveValue: { [weak self] _ in
                self?.getSchool()
            })
            .store(in: &self.cancellable)
        
        input.setCategory
            .debounce(for: .milliseconds(100), scheduler: RunLoop.main)
            .sink(receiveValue: { [weak self] category in
                guard let self = self else { return }
                self.category = category
                self.currentpageSize = self.pageSize
                self.lastReviewId = nil
                self.getReviewsBySchool()
                self.getStoresBySchool()
            })
            .store(in: &self.cancellable)
        
        input.setUniv
            .sink(receiveValue: { [weak self] univ in
                self?.setSchool(school: univ)
            })
            .store(in: &self.cancellable)
        
        input.customLocation
            .debounce(for: .milliseconds(100), scheduler: RunLoop.main)
            .sink(receiveValue: { [weak self] location in
                guard let self = self else { return }
                self.location = location
                self.currentpageSize = self.pageSize
                self.lastReviewId = nil
                self.getReviewsBySchool()
                self.getStoresBySchool()
            })
            .store(in: &self.cancellable)
        
        input.bookmarkButtonDidTap
            .sink(receiveValue: { [weak self] storeId, isBookmark in
                guard let self = self else { return }
                isBookmark ? self.removeBookmark(storeId: storeId) : self.createBookmark(storeId: storeId)
            })
            .store(in: &self.cancellable)
        
        input.scrolledToBottom
            .sink(receiveValue: { [weak self] _ in
                guard let self = self else { return }
                self.getReviewsBySchool(lastReviewId: self.lastReviewId)
            })
            .store(in: &self.cancellable)
        
        input.refreshControl
            .sink(receiveValue: { [weak self] _ in
                guard let self = self else { return }
                self.currentpageSize = self.pageSize
                self.lastReviewId = nil
                self.getReviewsBySchool()
            })
            .store(in: &self.cancellable)
        
        return Output(
            univ: self.univSubject.eraseToAnyPublisher(),
            stores: self.storesSubject.eraseToAnyPublisher(),
            reviews: self.reviewsSubject.eraseToAnyPublisher(),
            moreReviews: self.moreReviewsSubject.eraseToAnyPublisher(),
            isBookmarked: self.isBookmarkedSubject.eraseToAnyPublisher()
        )
    }
    
    private func getSchool() {
        if let schoolName = UserDefaultStorage.schoolName,
           let schoolX = UserDefaultStorage.schoolX,
           let schoolY = UserDefaultStorage.schoolY {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.05) {
                self.univSubject.send((schoolName, schoolX, schoolY))
            }
        }
    }
    
    private func setSchool(school: Store) {
        UserDefaultHandler.setSchoolId(schoolId: school.id)
        UserDefaultHandler.setSchoolName(schoolName: school.name)
        UserDefaultHandler.setSchoolX(schoolX: school.x)
        UserDefaultHandler.setSchoolY(schoolY: school.y)
        self.univSubject.send((school.name, school.x, school.y))
    }
    
    // MARK: - network
    
    private func getReviewsBySchool(lastReviewId: Int? = nil) {
        Task {
            do {
                guard let location = self.location, let schoolId = UserDefaultStorage.schoolId else { return }
                if self.currentpageSize < self.pageSize { return }
                
                let reviews = try await self.usecase.getReviewsBySchool(request: GetReviewsBySchoolRequestDTO(
                    location: location,
                    lastReviewId: lastReviewId,
                    pageSize: self.pageSize,
                    category: self.category?.rawValue,
                    schoolId: schoolId
                ))
                
                self.lastReviewId = reviews.page.lastId
                self.currentpageSize = reviews.page.size
                
                lastReviewId == nil ? self.reviewsSubject.send(.success(reviews.reviews)) : self.moreReviewsSubject.send(.success(reviews.reviews))
            } catch(let error) {
                self.reviewsSubject.send(.failure(error))
            }
        }
    }
    
    private func getStoresBySchool() {
        Task {
            do {
                guard let location = self.location, let schoolId = UserDefaultStorage.schoolId else { return }
                var stores = try await self.usecase.getStoresBySchool(request: GetStoresBySchoolRequestDTO(
                    location: location,
                    schoolId: schoolId
                ))
                
                if let category = self.category?.rawValue {
                    stores = stores.filter { $0.category == category }
                }
                
                self.storesSubject.send(.success(stores))
            } catch(let error) {
                self.storesSubject.send(.failure(error))
            }
        }
    }
    
    private func createBookmark(storeId: Int) {
        Task {
            do {
                try await self.usecase.createBookmark(storeId: storeId)
                self.isBookmarkedSubject.send(.success(storeId))
            } catch(let error) {
                self.isBookmarkedSubject.send(.failure(error))
            }
        }
    }
    
    private func removeBookmark(storeId: Int) {
        Task {
            do {
                try await self.usecase.removeBookmark(storeId: storeId)
                self.isBookmarkedSubject.send(.success(storeId))
            } catch(let error) {
                self.isBookmarkedSubject.send(.failure(error))
            }
        }
    }
}
